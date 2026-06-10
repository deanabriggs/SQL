USE mydb;

INSERT INTO customer (cust_id, first_name, last_name, email, phone, business)
VALUES 
	(1, 'John', 'Smith', 'js@email.com', NULL, NULL),
    (2, 'Abby', 'Roberts', 'ar@email.com', NULL, NULL),
    (3, 'Barb', 'Jones', 'bj@email.com', NULL, NULL),
    (4, 'Tony', 'Davis', 'td@xyzco.com', NULL, 'XYZ Company'),
    (5, 'David', 'Thomas', 'dt@me.com', NULL, NULL),
    (6, 'Bill', 'Wilson', 'billw@gmail.com', NULL, NULL),
    (7, 'Todd', 'Mathews', 'toddm@yahoo.com', NULL, NULL),
    (8, 'Chris', 'Jefferies', 'cj@abcinc.com', NULL, 'ABC Inc')
;

INSERT INTO address (address_id, address, city, state, zip)
VALUES 
	(501, '123 A St', 'Sacramento', 'CA', '95321'), 	-- 
    (502, '234 B St', 'Sacramento', 'CA', '95321'),		-- 
    (503, '345 C St', 'Sacramento', 'CA', '95321'),		-- 
    (504, '456 D St', 'Sacramento', 'CA', '95322'),		-- 
    (505, '678 F St', 'Roseville', 'CA', '95678'),		-- 
    (506, '789 G St', 'Roseville', 'CA', '95678'),		-- 
    (507, '901 I St', 'Roseville', 'CA', '95747'),		-- 
	(508, '123 1st Ave', 'Provo', 'UT', '84987'),		-- 
    (509, '234 2nd Ave', 'Provo', 'UT', '84987')		-- 
;

INSERT INTO project (proj_id, cust_id, address_id, lead_date, status, proj_name)
VALUES 
	(1001, 1, 501, '2025-01-02', 'Sold', '4 Camera System'),				-- John Smith @ 123 A St, Sacramento
	(1002, 2, 502, '2025-01-03', 'Sold', '3 Camera System'),				-- Abby Roberts @ 123 1st Ave, Provo 
	(1003, 3, 503, '2025-01-06', 'Considering', '6 Camera System'),			-- Barb Jones @ 234 2nd Ave, Provo
	(1004, 4, 504, '2025-01-07', 'Sold', '2 Camera System'),				-- XYZ Company @ 456 D St, Sacramento (has multi locations)
    (1005, 5, 505, '2025-01-09', 'Lost', '8 Camera System'), 				-- David Thomas @ 234 B St, Sacramento (moving)
    (1006, 6, 506, '2025-01-13', 'Sold', '2 Camera System'),				-- Bill Wilson @ 789 G St, Roseville
    (1007, 4, 507, '2025-01-15', 'Sold', '6 Camera System'),				-- XYZ Company @ 901 I St, Roseville (has multi locations)
    (1008, 7, 508, '2025-01-17', 'Lost', '3 Camera System'),				-- Todd Mathews @ 678 F St, Roseville
    (1009, 8, 509, '2025-01-21', 'Delayed', '12 Camera System')			-- ABC Company @ 345 C St, Sacramento
;

INSERT INTO category (cat_name, cat_print_desc)
VALUES 
	('camera', 'Cameras'),
    ('nvr', 'Recorder'),
    ('accessory', 'Supporting Hardware')
;    

INSERT INTO manufacturer (manu_id, manu_name, warranty)
VALUES 
	(1, 'HIK Vision', '4-year warranty on all video hardware'),
    (2, 'AXIS', '3-year warranty on all video hardware'),
    (3, 'Alarm.com', '1-year warranty on all video hardware'),
    (4, 'Western Digital', '3-year limited warranty')
;

INSERT INTO equipment (equip_id, equip_name, equip_print_desc, install_hours, equip_cost, cat_name, manu_id)
VALUES
	-- HIK products --
	(1, 'Turret', '4MP Turret Camera', 1.5, 100, 'camera', 1), 
    (2, 'Mini-dome', '4MP Mini-dome Camera', 1.5, 110, 'camera', 1), 
    (3, '4K Turret', '4K Turret Camera', 1.5, 175, 'camera', 1), 
    (4, 'Pano', '180 Degree Panoramin Camera', 2, 200, 'camera', 1), 
    (5, 'PTZ', '4x Pan-Tilt-Zoom Camera', 3, 550, 'camera', 1), 
    (6, 'PTZ 16', '16x Pan-Tilt-Zoom Camera', 3, 800, 'camera', 1), 
    (7, 'PTZ 32', '32x Pan-Tilt-Zoom Camera', 3, 1200, 'camera', 1), 
    (8, 'Doorbell', 'Video Doorbell Intercom', 2, 125, 'camera', 1), 
    (9, 'Bullet', '4MP Bullet Camera', 1.5, 100, 'camera', 1), 
    (10, '4K Bullet', '4K Bullet Camera', 1.5, 175, 'camera', 1), 
    (11, 'LPR', 'License Plate Reading Camera', 3, 1500, 'camera', 1), 
    (12, 'Dual PTZ-Pano', 'Dual View Pan-Tilt-Zoom and Panoramic Camera', 3.5, 2100, 'camera', 1), 
    (13, 'Dual LPR-Pano', 'Dual View License Plate Reader and Panoramic Camera', 3.5, 2200, 'camera', 1),
    (14, 'NVR 4ch', '4-channel Recorder', 2, 380, 'nvr', 1),
    (15, 'NVR 8ch', '8-channel Recorder', 2, 550, 'nvr', 1),
    (16, 'NVR 16ch', '16-channel Recorder', 2, 650, 'nvr', 1),
    (17, 'Back Box', 'Camera Back Box', 0, 15, 'accessory', 1),
    (18, 'Arm', 'Mounting Bracket', 0, 25, 'accessory', 1),
    -- AXIS products --
	(19, 'Dome Int', '2MP Indoor Dome Camera', 2, 300, 'camera', 2), 
    (20, 'Dome Ext', '4MP Outdoor Dome Camera', 2, 425, 'camera', 2), 
    (21, '4MP Bullet', '4MP Outdoor Bullet Camera', 2, 450, 'camera', 2), 
    (22, 'LPR 12MM', 'License Plate Reading Camera', 3, 2300, 'camera', 2), 
    (23, 'PTZ 32', '32x Pan-Tilt-Zoom Camera', 3, 1850, 'camera', 2), 
    (24, '360', '360 Degree Panoramic Camera', 3, 1850, 'camera', 2), 
    (25, 'NVR 8ch', '8-channel Recorder', 3, 1100, 'nvr', 2),
    (26, 'NVR 16ch', '16-channel Recorder', 3, 1700, 'nvr', 2),
    (27, 'Back Box', 'Camera Back Box', 0, 55, 'accessory', 2),
    (28, 'Arm', 'Mounting Bracket', 0, 95, 'accessory', 2),
    -- ADC products --
	(29, 'Turret', '4MP Turret Camera', 1.5, 100, 'camera', 3), 
    (30, 'Mini-dome', '4MP Mini-dome Camera', 1.5, 110, 'camera', 3), 
    (31, 'Doorbell', 'Video Doorbell Intercom', 2, 125, 'camera', 3), 
    (32, 'Bullet', '4MP Bullet Camera', 1.5, 100, 'camera', 3), 
    (33, 'NVR 8ch', '8-channel Recorder', 2, 750, 'nvr', 3),
    (34, 'Back Box', 'Camera Back Box', 0, 20, 'accessory', 3),
    (35, 'Arm', 'Mounting Bracket', 0, 30, 'accessory', 3),
    -- Western Digital products --
    (36, '8TB', '8TB Hard Drive', 0.1, 200, 'accessory', 4),
    (37, '10TB', '10TB Hard Drive', 0.1, 250, 'accessory', 4),
    (38, '14TB', '14TB Hard Drive', 0.1, 350, 'accessory', 4)
;

INSERT INTO feature (feature_id, feature_name, feature_print_desc)
VALUES 
	(1, 'IR', 'IR Night Vision'),
    (2, 'CV', 'Color Night Vision'),
    (3, 'Audio', 'Live and recorded audio'),
    (4, '2-way', '2-way voice communication'),
    (5, 'SD', 'SD card slot for on-board video storage'),
    (6, 'Continuous', '24/7 continuous recording'),
    (7, 'Cloud', 'Stores video clips to the cloud'),
    (8, 'Remote', 'Remote video access'),
    (9, 'Crossing', 'Line-crossing notifications'),
    (10, 'Analytics', 'Video analytics- distiguising between people, cars, and objects'),
    (11, 'Motion', 'Motion triggered notifications'),
    (12, 'Tracking', 'Tracking that follows moving objects'),
    (13, 'LPR', 'Captures and records license plates'),
    (14, 'PTZ', 'Pan-tilt-zoom for close up or wide view'),
    (15, '180', 'Two cameras digitally stitched together for one continuous view'),
    (16, 'Siren', 'Siren and strobe alarm to ward off intruders'),
    (17, 'Weather', 'Weatherproof (P67 rated)')
;

-- Insert values into equip_has_features --

INSERT INTO equip_has_feature
SELECT equip_id, feature_id
FROM equipment 
CROSS JOIN feature
WHERE cat_name = 'camera'
AND feature_id IN ( 2, 3, 5, 8, 9, 10, 11, 17);

INSERT INTO equip_has_feature
SELECT equip_id, feature_id
FROM equipment 
CROSS JOIN feature
WHERE cat_name = 'camera' 
AND manu_id = 3
AND feature_id IN ( 4, 7 );

INSERT INTO equip_has_feature
SELECT equip_id, feature_id
FROM equipment 
CROSS JOIN feature
WHERE equip_name LIKE '%Pano%'
AND feature_id IN ( 15, 16 );

INSERT INTO equip_has_feature
SELECT equip_id, feature_id
FROM equipment 
CROSS JOIN feature
WHERE equip_name LIKE '%PTZ%'
AND feature_id IN ( 12, 14);

INSERT INTO equip_has_feature
SELECT equip_id, feature_id
FROM equipment 
CROSS JOIN feature
WHERE equip_name LIKE '%LPR%'
AND feature_id IN ( 1, 13);

INSERT INTO equip_has_feature
SELECT equip_id, feature_id
FROM equipment 
CROSS JOIN feature
WHERE cat_name = 'nvr' 
AND feature_id IN ( 6, 8, 10 );

INSERT INTO rate (type, rate_per_unit, unit_desc)
VALUES 
	('commission', 0.2, '% of equip % labor'),
    ('labor', 40, '$ per hour'),
    ('profit', 0.4, '% of all costs');

