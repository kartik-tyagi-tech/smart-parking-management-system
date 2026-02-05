// server.js (CommonJS) — updated: static serving + /api/free
const express = require("express");
const cors = require("cors");
const oracledb = require("oracledb");
const path = require("path");

const app = express();
app.use(cors());
app.use(express.json());

// Serve index.html and static files from project root
app.use(express.static(path.join(__dirname)));
app.get("/", (req, res) => res.sendFile(path.join(__dirname, "index.html")));

// DB connection helper — update credentials if needed
async function getConnection() {
  return await oracledb.getConnection({
    user: "C##spms",
    password: "kamal735",
    connectString: "localhost:1521/XEPDB1", // or XEPDB1 if needed
  });
}

// --- API: list slots
app.get("/api/slots", async (req, res) => {
  console.log("GET /api/slots from", req.ip);
  let conn;
  try {
    conn = await getConnection();
    const result = await conn.execute(
      "SELECT slot_id, status, location_id FROM parking_slot ORDER BY slot_id",
      [],
      { outFormat: oracledb.OUT_FORMAT_OBJECT }
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Error /api/slots:", err);
    res.status(500).json({ error: err.message });
  } finally {
    if (conn) {
      try { await conn.close(); } catch (e) { console.error("close error", e); }
    }
  }
});

// --- API: book (calls your PL/SQL procedure book_slot)
app.post("/api/book", async (req, res) => {
  const { user_id, slot_id, start_time, end_time } = req.body;
  console.log("POST /api/book", { user_id, slot_id, start_time, end_time });
  let conn;
  try {
    conn = await getConnection();
    const result = await conn.execute(
      `BEGIN book_slot(:u, :s, TO_TIMESTAMP(:st,'YYYY-MM-DD HH24:MI:SS'),
                       TO_TIMESTAMP(:et,'YYYY-MM-DD HH24:MI:SS'),
                       :bid, :msg); END;`,
      {
        u: user_id,
        s: slot_id,
        st: start_time,
        et: end_time,
        bid: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER },
        msg: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 200 },
      },
      { autoCommit: true }
    );
    res.json(result.outBinds);
  } catch (err) {
    console.error("Error /api/book:", err);
    res.status(500).json({ error: err.message });
  } finally {
    if (conn) {
      try { await conn.close(); } catch (e) { console.error("close error", e); }
    }
  }
});

// --- API: free a slot (cancel bookings and set slot to AVAILABLE)
app.post("/api/free", async (req, res) => {
  const { slot_id } = req.body;
  if (!slot_id) return res.status(400).json({ error: "slot_id required" });

  console.log("POST /api/free", { slot_id });
  let conn;
  try {
    conn = await getConnection();

    // Cancel active bookings for this slot (adjust statuses to match your schema)
    await conn.execute(
      `UPDATE booking
         SET status = 'CANCELLED'
       WHERE slot_id = :sid AND status NOT IN ('CANCELLED','COMPLETED')`,
      [slot_id],
      { autoCommit: false }
    );

    // Set slot to AVAILABLE
    await conn.execute(
      `UPDATE parking_slot SET status = 'AVAILABLE' WHERE slot_id = :sid`,
      [slot_id],
      { autoCommit: false }
    );

    // Commit both statements together
    await conn.commit();

    res.json({ ok: true, slot_id });
  } catch (err) {
    if (conn) {
      try { await conn.rollback(); } catch (rbErr) { console.error("rollback error", rbErr); }
    }
    console.error("Error /api/free:", err);
    res.status(500).json({ error: err.message });
  } finally {
    if (conn) {
      try { await conn.close(); } catch (e) { console.error("close error", e); }
    }
  }
});

// --- Server start
const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));


