-- Keep a log of any SQL queries you execute as you solve the mystery.

--checking all tables inside database
.tables

--looking in crime scene reports to choose column to find out what happened on the day
.schema crime_scene_reports

SELECT description FROM crime_scene_reports WHERE month = 7 AND day = 28 AND street =
"Humphrey Street";

--.schema interviews finding more details about witnesses
SELECT transcript FROM interviews WHERE month = 7 AND day = 28 AND year = 2021; assuming intervews

--this gave transcript without names

SELECT * FROM interviews WHERE year = 2021 AND month = 7 AND day = 28;
-- to see transcript with names
-- Ruth, Eugene, Raymond saw activity around the crime

--Checking Ruth evidence first cars around crime scene
SELECT * FROM people WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs
   ...>  WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND minute >= 15 AND minute <= 25);
+--------+---------+----------------+-----------------+---------------+
|   id   |  name   |  phone_number  | passport_number | license_plate |
+--------+---------+----------------+-----------------+---------------+
| 221103 | Vanessa | (725) 555-4692 | 2963008352      | 5P2BI95       |
| 243696 | Barry   | (301) 555-4174 | 7526138472      | 6P58WS2       |
| 396669 | Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       |
| 398010 | Sofia   | (130) 555-0289 | 1695452385      | G412CB7       |
| 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       |
| 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       |
| 560886 | Kelsey  | (499) 555-9472 | 8294398571      | 0NTHK55       |
| 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       |
+--------+---------+----------------+-----------------+---------------+

-- List of possible suspects = (8) we will later cross reference license phone and passport
-- Checking Eugene statement of ATM activity
 SELECT name FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id
   ...> WHERE account_number IN (SELECT account_number FROM atm_transactions
   ...> WHERE atm_location = 'Leggett Street' AND year = 2021 AND month = 7 AND day = 28 AND transaction_type = 'withdraw');

+---------+
|  name   |
+---------+
| Bruce   |
| Diana   |
| Brooke  |
| Kenny   |
| Iman    |
| Luca    |
| Taylor  |
| Benista |
+---------+

-- 4 suspects who left the scene within 10 minutes of the crime
-- also appear in the list of names who withdrew money from the ATM that same day
-- Iman, Luca, Bruce, Diana this could narrow down our suspect list


--Now we will cross reference Raymonds evdience about phonecalls with our suspect list of 4

SELECT * FROM phone_calls WHERE caller IN (SELECT phone_number FROM people
   ...> WHERE name IN ('Iman', 'Luca', 'Bruce', 'Diana'));



   +-----+----------------+----------------+------+-------+-----+----------+
| id  |     caller     |    receiver    | year | month | day | duration |
+-----+----------------+----------------+------+-------+-----+----------+
| 9   | (367) 555-5533 | (113) 555-7544 | 2021 | 7     | 25  | 469      |
| 57  | (389) 555-5198 | (368) 555-3561 | 2021 | 7     | 25  | 414      |
| 104 | (367) 555-5533 | (238) 555-5554 | 2021 | 7     | 26  | 84       |
| 122 | (367) 555-5533 | (660) 555-3095 | 2021 | 7     | 26  | 399      |
| 133 | (367) 555-5533 | (286) 555-0131 | 2021 | 7     | 26  | 444      |
| 137 | (770) 555-1861 | (770) 555-1196 | 2021 | 7     | 26  | 163      |
| 198 | (770) 555-1861 | (680) 555-4935 | 2021 | 7     | 27  | 430      |
| 233 | (367) 555-5533 | (375) 555-8161 | 2021 | 7     | 28  | 45       |
| 236 | (367) 555-5533 | (344) 555-9601 | 2021 | 7     | 28  | 120      |
| 245 | (367) 555-5533 | (022) 555-4052 | 2021 | 7     | 28  | 241      |
| 255 | (770) 555-1861 | (725) 555-3243 | 2021 | 7     | 28  | 49       |
| 285 | (367) 555-5533 | (704) 555-5790 | 2021 | 7     | 28  | 75       |
| 326 | (389) 555-5198 | (609) 555-5876 | 2021 | 7     | 29  | 397      |
| 345 | (829) 555-5269 | (286) 555-0131 | 2021 | 7     | 29  | 337      |
| 395 | (367) 555-5533 | (455) 555-5315 | 2021 | 7     | 30  | 31       |
| 401 | (770) 555-1861 | (123) 555-5144 | 2021 | 7     | 30  | 491      |
| 418 | (367) 555-5533 | (841) 555-3728 | 2021 | 7     | 30  | 511      |
| 442 | (829) 555-5269 | (022) 555-4052 | 2021 | 7     | 30  | 232      |
| 465 | (829) 555-5269 | (367) 555-0409 | 2021 | 7     | 31  | 412      |
| 488 | (367) 555-5533 | (696) 555-9195 | 2021 | 7     | 31  | 261      |
+-----+----------------+----------------+------+-------+-----+----------+

--We need to narrow to 28th only
SELECT * FROM phone_calls WHERE caller IN (SELECT phone_number FROM people WHERE name IN ('Iman', 'Luca', 'Bruce', 'Diana'))
   ...> AND year = 2021 AND month = 7 AND day = 28;

+-----+----------------+----------------+------+-------+-----+----------+
| id  |     caller     |    receiver    | year | month | day | duration |
+-----+----------------+----------------+------+-------+-----+----------+
| 233 | (367) 555-5533 | (375) 555-8161 | 2021 | 7     | 28  | 45       |
| 236 | (367) 555-5533 | (344) 555-9601 | 2021 | 7     | 28  | 120      |
| 245 | (367) 555-5533 | (022) 555-4052 | 2021 | 7     | 28  | 241      |
| 255 | (770) 555-1861 | (725) 555-3243 | 2021 | 7     | 28  | 49       |
| 285 | (367) 555-5533 | (704) 555-5790 | 2021 | 7     | 28  | 75       |
+-----+----------------+----------------+------+-------+-----+----------+

-- From the evidence and cross reference we have two matching suspects
| 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       |
| 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       |

--Both Diana and bruce made short phone calls
-- as they both left the scene within 10mins, withdrew from atm and both made short calls on the day
-- Checking to see who they were calling on short calls

 SELECT * FROM people
   ...> WHERE phone_number IN (SELECT receiver FROM phone_calls
   ...> WHERE duration < 60 AND month = 7
   ...> AND day = 28
   ...> AND year = 2021
   ...> AND (caller = "(770) 555-1861" OR caller = "(367) 555-5533"));

-- possible accomplice is either Philip or Robin
+--------+--------+----------------+-----------------+---------------+
|   id   |  name  |  phone_number  | passport_number | license_plate |
+--------+--------+----------------+-----------------+---------------+
| 847116 | Philip | (725) 555-3243 | 3391710505      | GW362R6       |
| 864400 | Robin  | (375) 555-8161 |                 | 4V16VO0       |
+--------+--------+----------------+-----------------+---------------+

-- Diana called > Philip || Bruce called > Robin


-- Two key suspects and accomplee we will check the passport numbers against the earliest flight
-- Earlist Flight Check
SELECT * FROM flights WHERE month = 7 AND day = 29
   AND year = 2021;

+----+-------------------+------------------------+------+-------+-----+------+--------+
| id | origin_airport_id | destination_airport_id | year | month | day | hour | minute |
+----+-------------------+------------------------+------+-------+-----+------+--------+
| 18 | 8                 | 6                      | 2021 | 7     | 29  | 16   | 0      |
| 23 | 8                 | 11                     | 2021 | 7     | 29  | 12   | 15     |
| 36 | 8                 | 4                      | 2021 | 7     | 29  | 8    | 20     |
| 43 | 8                 | 1                      | 2021 | 7     | 29  | 9    | 30     |
| 53 | 8                 | 9                      | 2021 | 7     | 29  | 15   | 20     |
+----+-------------------+------------------------+------+-------+-----+------+--------+

--Flight ID earliest flight is 36 now we check against suspects

SELECT name FROM people WHERE passport_number IN (SELECT passport_number FROM passengers
   ...> WHERE flight_id = 36) AND (name = "Diana" OR name = "Philip" OR name = "Bruce" OR name = "Robin");
+-------+
| name  |
+-------+
| Bruce |
+-------+

-- Bruce is the thief we will check where he went.

SELECT city FROM airports
   ...> WHERE id = (SELECT destination_airport_id FROM flights
   ...> WHERE year = 2021 AND month = 7 AND day = 29 AND origin_airport_id = (SELECT id FROM airports WHERE city = "Fiftyville")
   ...> ORDER BY hour, minute LIMIT 1);
+---------------+
|     city      |
+---------------+
| New York City |
+---------------+

-- This means that the thief is bruce, he fled to New York City and his accomplice was Robin.
