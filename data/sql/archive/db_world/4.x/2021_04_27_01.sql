-- DB update 2021_04_27_00 -> 2021_04_27_01
DROP PROCEDURE IF EXISTS `updateDb`;
DELIMITER //
CREATE PROCEDURE updateDb ()
proc:BEGIN DECLARE OK VARCHAR(100) DEFAULT 'FALSE';
SELECT COUNT(*) INTO @COLEXISTS
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'version_db_world' AND COLUMN_NAME = '2021_04_27_00';
IF @COLEXISTS = 0 THEN LEAVE proc; END IF;
START TRANSACTION;
ALTER TABLE version_db_world CHANGE COLUMN 2021_04_27_00 2021_04_27_01 bit;
SELECT sql_rev INTO OK FROM version_db_world WHERE sql_rev = '1619538084717796794'; IF OK <> 'FALSE' THEN LEAVE proc; END IF;
--
-- START UPDATING QUERIES
--

INSERT INTO `version_db_world` (`sql_rev`) VALUES ('1619538084717796794');

SET
@POOL            = 11654,
@POOLSIZE        = 5,
@POOLDESC        = 'Treasures - Stranglethorn Vale',
@RESPAWN         = 900,
@GUID = '11970,12048,12054,85696,85695,85694,85693,100069,12169,87384,12119,85708,85711,11691,85860,12049';

-- Create pool(s)
DELETE FROM `pool_template` WHERE `entry`=@POOL;
INSERT INTO `pool_template` (`entry`,`max_limit`,`description`) VALUES (@POOL,@POOLSIZE,@POOLDESC);

-- Add gameobjects to pools
DELETE FROM `pool_gameobject` WHERE FIND_IN_SET (`guid`,@GUID);
INSERT INTO `pool_gameobject` (`guid`,`pool_entry`,`chance`,`description`) VALUES
(11970,@POOL,0,@POOLDESC),
(12048,@POOL,0,@POOLDESC),
(12054,@POOL,0,@POOLDESC),
(85696,@POOL,0,@POOLDESC),
(85695,@POOL,0,@POOLDESC),
(85694,@POOL,0,@POOLDESC),
(85693,@POOL,0,@POOLDESC),
(100069,@POOL,0,@POOLDESC),
(12169,@POOL,0,@POOLDESC),
(87384,@POOL,0,@POOLDESC),
(12119,@POOL,0,@POOLDESC),
(85708,@POOL,0,@POOLDESC),
(85711,@POOL,0,@POOLDESC),
(11691,@POOL,0,@POOLDESC),
(85860,@POOL,0,@POOLDESC),
(12049,@POOL,0,@POOLDESC);

-- Respawn rates of gameobjects
UPDATE `gameobject` SET `spawntimesecs`=@RESPAWN WHERE FIND_IN_SET (`guid`,@GUID);


--
-- END UPDATING QUERIES
--
COMMIT;
END //
DELIMITER ;
CALL updateDb();
DROP PROCEDURE IF EXISTS `updateDb`;