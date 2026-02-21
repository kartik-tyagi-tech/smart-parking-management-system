-- ===============================
-- PROCEDURE: BOOK_SLOT
-- ===============================

SET SERVEROUTPUT ON SIZE UNLIMITED;

CREATE OR REPLACE PROCEDURE book_slot(
 p_user_id IN NUMBER,
 p_slot_id IN NUMBER,
 p_start IN TIMESTAMP,
 p_end IN TIMESTAMP,
 p_booking_id OUT NUMBER,
 p_status_msg OUT VARCHAR2
) AS
 v_status parking_slot.status%TYPE;
BEGIN
 BEGIN
  SELECT status INTO v_status
  FROM parking_slot
  WHERE slot_id = p_slot_id
  FOR UPDATE;
 EXCEPTION
  WHEN NO_DATA_FOUND THEN
   p_status_msg := 'SLOT_NOT_FOUND';
   p_booking_id := NULL;
   RETURN;
 END;

 IF v_status != 'AVAILABLE' THEN
  p_status_msg := 'SLOT_NOT_AVAILABLE';
  p_booking_id := NULL;
  RETURN;
 END IF;

 INSERT INTO booking(user_id, slot_id, start_time, end_time, status)
 VALUES (p_user_id, p_slot_id, p_start, p_end, 'CONFIRMED')
 RETURNING booking_id INTO p_booking_id;

 UPDATE parking_slot
 SET status = 'BOOKED'
 WHERE slot_id = p_slot_id;

 p_status_msg := 'BOOKING_SUCCESS';

 COMMIT;

EXCEPTION
 WHEN OTHERS THEN
  ROLLBACK;
  p_status_msg := 'ERROR: ' || SQLERRM;
  p_booking_id := NULL;
END book_slot;
/