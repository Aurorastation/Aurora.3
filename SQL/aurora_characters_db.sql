SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


CREATE TABLE `characters_data` (
  `Id` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `OOC` varchar(512) DEFAULT NULL,
  `name` varchar(128) NOT NULL,
  `isRandom` tinyint(1) DEFAULT NULL,
  `gender` varchar(32) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `species` varchar(32) DEFAULT NULL,
  `language` varchar(128) DEFAULT NULL,
  `hair_R` int(11) DEFAULT NULL,
  `hair_G` int(11) DEFAULT NULL,
  `hair_B` int(11) DEFAULT NULL,
  `facial_R` int(11) DEFAULT NULL,
  `facial_G` int(11) DEFAULT NULL,
  `facial_B` int(11) DEFAULT NULL,
  `skin_tone` int(11) DEFAULT NULL,
  `skin_R` int(11) DEFAULT NULL,
  `skin_G` int(11) DEFAULT NULL,
  `skin_B` int(11) DEFAULT NULL,
  `hair_style` varchar(32) DEFAULT NULL,
  `facial_style` varchar(32) DEFAULT NULL,
  `eyes_R` int(11) DEFAULT NULL,
  `eyes_G` int(11) DEFAULT NULL,
  `eyes_B` int(11) DEFAULT NULL,
  `underwear` varchar(32) DEFAULT NULL,
  `undershirt` varchar(32) DEFAULT NULL,
  `backbag` int(11) DEFAULT NULL,
  `b_type` varchar(32) DEFAULT NULL,
  `spawnpoint` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `characters_flavour` (
  `id` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `generals` text NOT NULL,
  `head` text NOT NULL,
  `face` text NOT NULL,
  `eyes` text NOT NULL,
  `torso` text NOT NULL,
  `arms` text NOT NULL,
  `hands` text NOT NULL,
  `legs` text NOT NULL,
  `feet` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

CREATE TABLE `characters_gear` (
  `id` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `gear` mediumtext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `characters_jobs` (
  `id` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `Alternate` int(11) NOT NULL,
  `civ_high` int(11) NOT NULL,
  `civ_med` int(11) NOT NULL,
  `civ_low` int(11) NOT NULL,
  `medsci_high` int(11) NOT NULL,
  `medsci_med` int(11) NOT NULL,
  `medsci_low` int(11) NOT NULL,
  `engsec_high` int(11) NOT NULL,
  `engsec_med` int(11) NOT NULL,
  `engsec_low` int(11) NOT NULL,
  `alt_titles` mediumtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

CREATE TABLE `characters_misc` (
  `id` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `med_rec` text NOT NULL,
  `sec_rec` text NOT NULL,
  `gen_rec` text NOT NULL,
  `disab` text NOT NULL,
  `used_skill` int(11) NOT NULL,
  `skills_spec` text NOT NULL,
  `home_sys` text NOT NULL,
  `citizen` text NOT NULL,
  `faction` text NOT NULL,
  `religion` text NOT NULL,
  `NT_relation` text NOT NULL,
  `uplink_loc` text NOT NULL,
  `exploit_rec` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `characters_organs` (
  `id` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `l_leg` text,
  `r_leg` text,
  `l_arm` text,
  `r_arm` text,
  `l_foot` text,
  `r_foot` text,
  `l_hand` text,
  `r_hand` text,
  `heart` text,
  `eyes` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `characters_rlimb` (
  `id` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `l_leg` text,
  `r_leg` text,
  `l_arm` text,
  `r_arm` text,
  `l_foot` text,
  `r_foot` text,
  `l_hand` text,
  `r_hand` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `characters_robot_flavour` (
  `id` int(11) NOT NULL,
  `char_id` int(11) DEFAULT NULL,
  `Default_Robot` text,
  `Standard` text,
  `Engineering` text,
  `Construction` text,
  `Surgeon` text,
  `Crisis` text,
  `Miner` text,
  `Janitor` text,
  `Service` text,
  `Clerical` text,
  `Security` text,
  `Research` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `characters_skills` (
  `id` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `Command` int(11) DEFAULT NULL,
  `Botany` int(11) DEFAULT NULL,
  `Cooking` int(11) DEFAULT NULL,
  `Close_Combat` int(11) DEFAULT NULL,
  `Weapons_Expertise` int(11) DEFAULT NULL,
  `Forensics` int(11) DEFAULT NULL,
  `NanoTrasen_Law` int(11) DEFAULT NULL,
  `EVA` int(11) DEFAULT NULL,
  `Construction` int(11) DEFAULT NULL,
  `Electrical` int(11) DEFAULT NULL,
  `Atmos` int(11) DEFAULT NULL,
  `Engines` int(11) DEFAULT NULL,
  `Heavy_Mach` int(11) DEFAULT NULL,
  `Complex_Devices` int(11) DEFAULT NULL,
  `Information_Tech` int(11) DEFAULT NULL,
  `Genetics` int(11) DEFAULT NULL,
  `Chemistry` int(11) DEFAULT NULL,
  `Science` int(11) DEFAULT NULL,
  `Medicine` int(11) DEFAULT NULL,
  `Anatomy` int(11) DEFAULT NULL,
  `Virology` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `player_preferences` (
  `id` int(11) NOT NULL,
  `ckey` text NOT NULL,
  `ooccolor` text NOT NULL,
  `lastchangelog` text NOT NULL,
  `UI_style` text NOT NULL,
  `default_slot` int(11) NOT NULL,
  `toggles` int(11) NOT NULL,
  `UI_style_color` text NOT NULL,
  `UI_style_alpha` int(11) NOT NULL,
  `be_special` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ss13_characters` (
  `id` int(11) NOT NULL,
  `ckey` varchar(32) DEFAULT NULL,
  `slot` int(11) DEFAULT '0',
  `Character_Name` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;


ALTER TABLE `characters_data`
  ADD PRIMARY KEY (`Id`);

ALTER TABLE `characters_flavour`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `characters_gear`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `characters_jobs`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `characters_misc`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `characters_organs`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `characters_rlimb`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `characters_robot_flavour`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `characters_skills`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `player_preferences`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `ss13_characters`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `characters_data`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `characters_flavour`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `characters_gear`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `characters_jobs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `characters_misc`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `characters_organs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `characters_rlimb`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `characters_robot_flavour`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `characters_skills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `player_preferences`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `ss13_characters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
