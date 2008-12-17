-- 
-- Database: `openemr`
-- 

-- --------------------------------------------------------

-- 
-- Table structure for table `addresses`
-- 

DROP TABLE IF EXISTS `addresses`;
CREATE TABLE `addresses` (
  `id` int(11) NOT NULL default '0',
  `line1` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `line2` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `city` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `state` varchar(35) character set utf8 collate utf8_unicode_ci default NULL,
  `zip` varchar(10) character set utf8 collate utf8_unicode_ci default NULL,
  `plus_four` varchar(4) character set utf8 collate utf8_unicode_ci default NULL,
  `country` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `foreign_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `foreign_id` (`foreign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `array`
-- 

DROP TABLE IF EXISTS `array`;
CREATE TABLE `array` (
  `array_key` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `array_value` longtext character set utf8 collate utf8_unicode_ci
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `batchcom`
-- 

DROP TABLE IF EXISTS `batchcom`;
CREATE TABLE `batchcom` (
  `id` bigint(20) NOT NULL auto_increment,
  `patient_id` int(11) NOT NULL default '0',
  `sent_by` bigint(20) NOT NULL default '0',
  `msg_type` varchar(60) character set utf8 collate utf8_unicode_ci default NULL,
  `msg_subject` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `msg_text` mediumtext character set utf8 collate utf8_unicode_ci,
  `msg_date_sent` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `billing`
-- 

DROP TABLE IF EXISTS `billing`;
CREATE TABLE `billing` (
  `id` int(11) NOT NULL auto_increment,
  `date` datetime default NULL,
  `code_type` varchar(7) character set utf8 collate utf8_unicode_ci default NULL,
  `code` varchar(9) character set utf8 collate utf8_unicode_ci default NULL,
  `pid` int(11) default NULL,
  `provider_id` int(11) default NULL,
  `user` int(11) default NULL,
  `groupname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `authorized` tinyint(1) default NULL,
  `encounter` int(11) default NULL,
  `code_text` longtext character set utf8 collate utf8_unicode_ci,
  `billed` tinyint(1) default NULL,
  `activity` tinyint(1) default NULL,
  `payer_id` int(11) default NULL,
  `bill_process` tinyint(2) NOT NULL default '0',
  `bill_date` datetime default NULL,
  `process_date` datetime default NULL,
  `process_file` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `modifier` varchar(5) character set utf8 collate utf8_unicode_ci default NULL,
  `units` tinyint(3) default NULL,
  `fee` decimal(12,2) default NULL,
  `justify` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `target` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `x12_partner_id` int(11) default NULL,
  `ndc_info` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `categories`
-- 

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `value` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `parent` int(11) NOT NULL default '0',
  `lft` int(11) NOT NULL default '0',
  `rght` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `parent` (`parent`),
  KEY `lft` (`lft`,`rght`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 
-- Dumping data for table `categories`
-- 

INSERT INTO `categories` VALUES (1, 'Categories', '', 0, 0, 9);
INSERT INTO `categories` VALUES (2, 'Lab Report', '', 1, 1, 2);
INSERT INTO `categories` VALUES (3, 'Medical Record', '', 1, 3, 4);
INSERT INTO `categories` VALUES (4, 'Patient Information', '', 1, 5, 8);
INSERT INTO `categories` VALUES (5, 'Patient ID card', '', 4, 6, 7);

-- --------------------------------------------------------

-- 
-- Table structure for table `categories_seq`
-- 

DROP TABLE IF EXISTS `categories_seq`;
CREATE TABLE `categories_seq` (
  `id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 
-- Dumping data for table `categories_seq`
-- 

INSERT INTO `categories_seq` VALUES (5);

-- --------------------------------------------------------

-- 
-- Table structure for table `categories_to_documents`
-- 

DROP TABLE IF EXISTS `categories_to_documents`;
CREATE TABLE `categories_to_documents` (
  `category_id` int(11) NOT NULL default '0',
  `document_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`category_id`,`document_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `claims`
-- 

DROP TABLE IF EXISTS `claims`;
CREATE TABLE `claims` (
  `patient_id` int(11) NOT NULL,
  `encounter_id` int(11) NOT NULL,
  `version` int(10) unsigned NOT NULL auto_increment,
  `payer_id` int(11) NOT NULL default '0',
  `status` tinyint(2) NOT NULL default '0',
  `payer_type` tinyint(4) NOT NULL default '0',
  `bill_process` tinyint(2) NOT NULL default '0',
  `bill_time` datetime default NULL,
  `process_time` datetime default NULL,
  `process_file` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `target` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `x12_partner_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`patient_id`,`encounter_id`,`version`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `codes`
-- 

DROP TABLE IF EXISTS `codes`;
CREATE TABLE `codes` (
  `id` int(11) NOT NULL auto_increment,
  `code_text` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `code_text_short` varchar(24) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `code` varchar(10) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `code_type` tinyint(2) default NULL,
  `modifier` varchar(5) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `units` tinyint(3) default NULL,
  `fee` decimal(12,2) default NULL,
  `superbill` varchar(31) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `related_code` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `taxrates` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `cyp_factor` float NOT NULL DEFAULT 0 COMMENT 'quantity representing a years supply',
  PRIMARY KEY  (`id`),
  KEY `code` (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `config`
-- 

DROP TABLE IF EXISTS `config`;
CREATE TABLE `config` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `value` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `parent` int(11) NOT NULL default '0',
  `lft` int(11) NOT NULL default '0',
  `rght` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `parent` (`parent`),
  KEY `lft` (`lft`,`rght`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `config_seq`
-- 

DROP TABLE IF EXISTS `config_seq`;
CREATE TABLE `config_seq` (
  `id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 
-- Dumping data for table `config_seq`
-- 

INSERT INTO `config_seq` VALUES (0);

-- --------------------------------------------------------

-- 
-- Table structure for table `documents`
-- 

DROP TABLE IF EXISTS `documents`;
CREATE TABLE `documents` (
  `id` int(11) NOT NULL default '0',
  `type` enum('file_url','blob','web_url') character set latin1 default NULL,
  `size` int(11) default NULL,
  `date` datetime default NULL,
  `url` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `mimetype` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `pages` int(11) default NULL,
  `owner` int(11) default NULL,
  `revision` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `foreign_id` int(11) default NULL,
  `docdate` date default NULL,
  `list_id` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `revision` (`revision`),
  KEY `foreign_id` (`foreign_id`),
  KEY `owner` (`owner`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `drug_inventory`
-- 

DROP TABLE IF EXISTS `drug_inventory`;
CREATE TABLE `drug_inventory` (
  `inventory_id` int(11) NOT NULL auto_increment,
  `drug_id` int(11) NOT NULL,
  `lot_number` varchar(20) character set utf8 collate utf8_unicode_ci default NULL,
  `expiration` date default NULL,
  `manufacturer` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `on_hand` int(11) NOT NULL default '0',
  `last_notify` date NOT NULL default '0000-00-00',
  `destroy_date` date default NULL,
  `destroy_method` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `destroy_witness` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `destroy_notes` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`inventory_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `drug_sales`
-- 

DROP TABLE IF EXISTS `drug_sales`;
CREATE TABLE `drug_sales` (
  `sale_id` int(11) NOT NULL auto_increment,
  `drug_id` int(11) NOT NULL,
  `inventory_id` int(11) NOT NULL,
  `prescription_id` int(11) NOT NULL default '0',
  `pid` int(11) NOT NULL default '0',
  `encounter` int(11) NOT NULL default '0',
  `user` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `sale_date` date NOT NULL,
  `quantity` int(11) NOT NULL default '0',
  `fee` decimal(12,2) NOT NULL default '0.00',
  `billed` tinyint(1) NOT NULL default '0' COMMENT 'indicates if the sale is posted to accounting',
  PRIMARY KEY  (`sale_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `drug_templates`
-- 

DROP TABLE IF EXISTS `drug_templates`;
CREATE TABLE `drug_templates` (
  `drug_id` int(11) NOT NULL,
  `selector` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `dosage` varchar(10) character set utf8 collate utf8_unicode_ci default NULL,
  `period` int(11) NOT NULL default '0',
  `quantity` int(11) NOT NULL default '0',
  `refills` int(11) NOT NULL default '0',
  `taxrates` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`drug_id`,`selector`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `drugs`
-- 

DROP TABLE IF EXISTS `drugs`;
CREATE TABLE `drugs` (
  `drug_id` int(11) NOT NULL auto_increment,
  `name` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `ndc_number` varchar(20) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `on_order` int(11) NOT NULL default '0',
  `reorder_point` int(11) NOT NULL default '0',
  `last_notify` date NOT NULL default '0000-00-00',
  `reactions` text character set utf8 collate utf8_unicode_ci,
  `form` int(3) NOT NULL default '0',
  `size` float unsigned NOT NULL default '0',
  `unit` int(11) NOT NULL default '0',
  `route` int(11) NOT NULL default '0',
  `substitute` int(11) NOT NULL default '0',
  `related_code` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'may reference a related codes.code',
  `cyp_factor` float NOT NULL DEFAULT 0 COMMENT 'quantity representing a years supply',
  PRIMARY KEY  (`drug_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `employer_data`
-- 

DROP TABLE IF EXISTS `employer_data`;
CREATE TABLE `employer_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `name` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `street` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `postal_code` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `city` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `state` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `country` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `date` datetime default NULL,
  `pid` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `facility`
-- 

DROP TABLE IF EXISTS `facility`;
CREATE TABLE `facility` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `phone` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `fax` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `street` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `city` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `state` varchar(50) character set utf8 collate utf8_unicode_ci default NULL,
  `postal_code` varchar(11) character set utf8 collate utf8_unicode_ci default NULL,
  `country_code` varchar(10) character set utf8 collate utf8_unicode_ci default NULL,
  `federal_ein` varchar(15) character set utf8 collate utf8_unicode_ci default NULL,
  `service_location` tinyint(1) NOT NULL default '1',
  `billing_location` tinyint(1) NOT NULL default '0',
  `accepts_assignment` tinyint(1) NOT NULL default '0',
  `pos_code` tinyint(4) default NULL,
  `x12_sender_id` varchar(25) character set utf8 collate utf8_unicode_ci default NULL,
  `attn` varchar(65) character set utf8 collate utf8_unicode_ci default NULL,
  `domain_identifier` varchar(60) character set utf8 collate utf8_unicode_ci default NULL,
  `facility_npi` varchar(15) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=4 ;

-- 
-- Dumping data for table `facility`
-- 

INSERT INTO `facility` VALUES (3, 'Your Clinic Name Here', '000-000-0000', '000-000-0000', '', '', '', '', '', '', 1, 0, 0, NULL, '', '', '', '');

-- --------------------------------------------------------

-- 
-- Table structure for table `fee_sheet_options`
-- 

DROP TABLE IF EXISTS `fee_sheet_options`;
CREATE TABLE `fee_sheet_options` (
  `fs_category` varchar(63) character set utf8 collate utf8_unicode_ci default NULL,
  `fs_option` varchar(63) character set utf8 collate utf8_unicode_ci default NULL,
  `fs_codes` varchar(255) character set utf8 collate utf8_unicode_ci default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 
-- Dumping data for table `fee_sheet_options`
-- 

INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '1Brief', 'CPT4|99201|');
INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '2Limited', 'CPT4|99202|');
INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '3Detailed', 'CPT4|99203|');
INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '4Extended', 'CPT4|99204|');
INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '5Comprehensive', 'CPT4|99205|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '1Brief', 'CPT4|99211|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '2Limited', 'CPT4|99212|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '3Detailed', 'CPT4|99213|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '4Extended', 'CPT4|99214|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '5Comprehensive', 'CPT4|99215|');

-- --------------------------------------------------------

-- 
-- Table structure for table `form_dictation`
-- 

DROP TABLE IF EXISTS `form_dictation`;
CREATE TABLE `form_dictation` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default NULL,
  `user` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `groupname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `authorized` tinyint(4) default NULL,
  `activity` tinyint(4) default NULL,
  `dictation` longtext character set utf8 collate utf8_unicode_ci,
  `additional_notes` longtext character set utf8 collate utf8_unicode_ci,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_encounter`
-- 

DROP TABLE IF EXISTS `form_encounter`;
CREATE TABLE `form_encounter` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `reason` longtext character set utf8 collate utf8_unicode_ci,
  `facility` longtext character set utf8 collate utf8_unicode_ci,
  `facility_id` int(11) NOT NULL default '0',
  `pid` bigint(20) default NULL,
  `encounter` bigint(20) default NULL,
  `onset_date` datetime default NULL,
  `sensitivity` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `billing_note` text character set utf8 collate utf8_unicode_ci,
  `pc_catid` int(11) NOT NULL default '5' COMMENT 'event category from openemr_postcalendar_categories',
  `last_level_billed` int  NOT NULL DEFAULT 0 COMMENT '0=none, 1=ins1, 2=ins2, etc',
  `last_level_closed` int  NOT NULL DEFAULT 0 COMMENT '0=none, 1=ins1, 2=ins2, etc',
  `last_stmt_date`    date DEFAULT NULL,
  `stmt_count`        int  NOT NULL DEFAULT 0,
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_misc_billing_options`
-- 

DROP TABLE IF EXISTS `form_misc_billing_options`;
CREATE TABLE `form_misc_billing_options` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default NULL,
  `user` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `groupname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `authorized` tinyint(4) default NULL,
  `activity` tinyint(4) default NULL,
  `employment_related` tinyint(1) default NULL,
  `auto_accident` tinyint(1) default NULL,
  `accident_state` varchar(2) character set utf8 collate utf8_unicode_ci default NULL,
  `other_accident` tinyint(1) default NULL,
  `outside_lab` tinyint(1) default NULL,
  `lab_amount` decimal(5,2) default NULL,
  `is_unable_to_work` tinyint(1) default NULL,
  `off_work_from` date default NULL,
  `off_work_to` date default NULL,
  `is_hospitalized` tinyint(1) default NULL,
  `hospitalization_date_from` date default NULL,
  `hospitalization_date_to` date default NULL,
  `medicaid_resubmission_code` varchar(10) character set utf8 collate utf8_unicode_ci default NULL,
  `medicaid_original_reference` varchar(15) character set utf8 collate utf8_unicode_ci default NULL,
  `prior_auth_number` varchar(20) character set utf8 collate utf8_unicode_ci default NULL,
  `comments` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `replacement_claim` tinyint(1) default 0,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_reviewofs`
-- 

DROP TABLE IF EXISTS `form_reviewofs`;
CREATE TABLE `form_reviewofs` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default NULL,
  `user` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `groupname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `authorized` tinyint(4) default NULL,
  `activity` tinyint(4) default NULL,
  `fever` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `chills` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `night_sweats` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `weight_loss` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `poor_appetite` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `insomnia` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `fatigued` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `depressed` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `hyperactive` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `exposure_to_foreign_countries` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `cataracts` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `cataract_surgery` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `glaucoma` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `double_vision` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `blurred_vision` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `poor_hearing` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `headaches` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `ringing_in_ears` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `bloody_nose` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `sinusitis` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `sinus_surgery` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `dry_mouth` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `strep_throat` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `tonsillectomy` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `swollen_lymph_nodes` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `throat_cancer` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `throat_cancer_surgery` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `heart_attack` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `irregular_heart_beat` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `chest_pains` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `shortness_of_breath` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `high_blood_pressure` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `heart_failure` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `poor_circulation` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `vascular_surgery` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `cardiac_catheterization` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `coronary_artery_bypass` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `heart_transplant` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `stress_test` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `emphysema` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `chronic_bronchitis` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `interstitial_lung_disease` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `shortness_of_breath_2` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `lung_cancer` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `lung_cancer_surgery` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `pheumothorax` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `stomach_pains` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `peptic_ulcer_disease` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `gastritis` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `endoscopy` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `polyps` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `colonoscopy` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `colon_cancer` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `colon_cancer_surgery` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `ulcerative_colitis` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `crohns_disease` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `appendectomy` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `divirticulitis` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `divirticulitis_surgery` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `gall_stones` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `cholecystectomy` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `hepatitis` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `cirrhosis_of_the_liver` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `splenectomy` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `kidney_failure` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `kidney_stones` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `kidney_cancer` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `kidney_infections` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `bladder_infections` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `bladder_cancer` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `prostate_problems` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `prostate_cancer` varchar(255) character set latin1 default NULL,
  `kidney_transplant` varchar(255) character set latin1 default NULL,
  `sexually_transmitted_disease` varchar(255) character set latin1 default NULL,
  `burning_with_urination` varchar(255) character set latin1 default NULL,
  `discharge_from_urethra` varchar(255) character set latin1 default NULL,
  `rashes` varchar(255) character set latin1 default NULL,
  `infections` varchar(255) character set latin1 default NULL,
  `ulcerations` varchar(255) character set latin1 default NULL,
  `pemphigus` varchar(255) character set latin1 default NULL,
  `herpes` varchar(255) character set latin1 default NULL,
  `osetoarthritis` varchar(255) character set latin1 default NULL,
  `rheumotoid_arthritis` varchar(255) character set latin1 default NULL,
  `lupus` varchar(255) character set latin1 default NULL,
  `ankylosing_sondlilitis` varchar(255) character set latin1 default NULL,
  `swollen_joints` varchar(255) character set latin1 default NULL,
  `stiff_joints` varchar(255) character set latin1 default NULL,
  `broken_bones` varchar(255) character set latin1 default NULL,
  `neck_problems` varchar(255) character set latin1 default NULL,
  `back_problems` varchar(255) character set latin1 default NULL,
  `back_surgery` varchar(255) character set latin1 default NULL,
  `scoliosis` varchar(255) character set latin1 default NULL,
  `herniated_disc` varchar(255) character set latin1 default NULL,
  `shoulder_problems` varchar(255) character set latin1 default NULL,
  `elbow_problems` varchar(255) character set latin1 default NULL,
  `wrist_problems` varchar(255) character set latin1 default NULL,
  `hand_problems` varchar(255) character set latin1 default NULL,
  `hip_problems` varchar(255) character set latin1 default NULL,
  `knee_problems` varchar(255) character set latin1 default NULL,
  `ankle_problems` varchar(255) character set latin1 default NULL,
  `foot_problems` varchar(255) character set latin1 default NULL,
  `insulin_dependent_diabetes` varchar(255) character set latin1 default NULL,
  `noninsulin_dependent_diabetes` varchar(255) character set latin1 default NULL,
  `hypothyroidism` varchar(255) character set latin1 default NULL,
  `hyperthyroidism` varchar(255) character set latin1 default NULL,
  `cushing_syndrom` varchar(255) character set latin1 default NULL,
  `addison_syndrom` varchar(255) character set latin1 default NULL,
  `additional_notes` longtext character set utf8 collate utf8_unicode_ci,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_ros`
-- 

DROP TABLE IF EXISTS `form_ros`;
CREATE TABLE `form_ros` (
  `id` int(11) NOT NULL auto_increment,
  `pid` int(11) NOT NULL,
  `activity` int(11) NOT NULL default '1',
  `date` datetime default NULL,
  `weight_change` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `weakness` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `fatigue` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `anorexia` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `fever` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `chills` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `night_sweats` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `insomnia` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `irritability` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `heat_or_cold` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `intolerance` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `change_in_vision` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `glaucoma_history` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `eye_pain` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `irritation` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `redness` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `excessive_tearing` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `double_vision` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `blind_spots` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `photophobia` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `hearing_loss` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `discharge` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `pain` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `vertigo` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `tinnitus` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `frequent_colds` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `sore_throat` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `sinus_problems` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `post_nasal_drip` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `nosebleed` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `snoring` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `apnea` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `breast_mass` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `breast_discharge` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `biopsy` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `abnormal_mammogram` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `cough` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `sputum` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `shortness_of_breath` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `wheezing` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `hemoptsyis` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `asthma` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `copd` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `chest_pain` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `palpitation` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `syncope` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `pnd` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `doe` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `orthopnea` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `peripheal` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `edema` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `legpain_cramping` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `history_murmur` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `arrythmia` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `heart_problem` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `dysphagia` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `heartburn` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `bloating` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `belching` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `flatulence` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `nausea` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `vomiting` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `hematemesis` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `gastro_pain` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `food_intolerance` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `hepatitis` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `jaundice` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `hematochezia` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `changed_bowel` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `diarrhea` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `constipation` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `polyuria` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `polydypsia` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `dysuria` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `hematuria` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `frequency` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `urgency` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `incontinence` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `renal_stones` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `utis` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `hesitancy` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `dribbling` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `stream` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `nocturia` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `erections` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `ejaculations` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `g` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `p` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `ap` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `lc` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `mearche` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `menopause` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `lmp` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `f_frequency` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `f_flow` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `f_symptoms` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `abnormal_hair_growth` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `f_hirsutism` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `joint_pain` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `swelling` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `m_redness` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `m_warm` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `m_stiffness` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `muscle` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `m_aches` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `fms` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `arthritis` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `loc` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `seizures` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `stroke` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `tia` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `n_numbness` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `n_weakness` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `paralysis` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `intellectual_decline` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `memory_problems` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `dementia` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `n_headache` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `s_cancer` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `psoriasis` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `s_acne` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `s_other` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `s_disease` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `p_diagnosis` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `p_medication` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `depression` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `anxiety` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `social_difficulties` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `thyroid_problems` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `diabetes` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `abnormal_blood` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `anemia` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `fh_blood_problems` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `bleeding_problems` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `allergies` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `frequent_illness` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `hiv` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `hai_status` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_soap`
-- 

DROP TABLE IF EXISTS `form_soap`;
CREATE TABLE `form_soap` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default '0',
  `user` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `groupname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `authorized` tinyint(4) default '0',
  `activity` tinyint(4) default '0',
  `subjective` text character set utf8 collate utf8_unicode_ci,
  `objective` text character set utf8 collate utf8_unicode_ci,
  `assessment` text character set utf8 collate utf8_unicode_ci,
  `plan` text character set utf8 collate utf8_unicode_ci,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_vitals`
-- 

DROP TABLE IF EXISTS `form_vitals`;
CREATE TABLE `form_vitals` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default '0',
  `user` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `groupname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `authorized` tinyint(4) default '0',
  `activity` tinyint(4) default '0',
  `bps` varchar(40) character set utf8 collate utf8_unicode_ci default NULL,
  `bpd` varchar(40) character set utf8 collate utf8_unicode_ci default NULL,
  `weight` float(5,2) default '0.00',
  `height` float(5,2) default '0.00',
  `temperature` float(5,2) default '0.00',
  `temp_method` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `pulse` float(5,2) default '0.00',
  `respiration` float(5,2) default '0.00',
  `note` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `BMI` float(4,1) default '0.0',
  `BMI_status` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `waist_circ` float(5,2) default '0.00',
  `head_circ` float(4,2) default '0.00',
  `oxygen_saturation` float(5,2) default '0.00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `forms`
-- 

DROP TABLE IF EXISTS `forms`;
CREATE TABLE `forms` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `encounter` bigint(20) default NULL,
  `form_name` longtext character set utf8 collate utf8_unicode_ci,
  `form_id` bigint(20) default NULL,
  `pid` bigint(20) default NULL,
  `user` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `groupname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `authorized` tinyint(4) default NULL,
  `formdir` longtext character set utf8 collate utf8_unicode_ci,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `geo_country_reference`
-- 

DROP TABLE IF EXISTS `geo_country_reference`;
CREATE TABLE `geo_country_reference` (
  `countries_id` int(5) NOT NULL auto_increment,
  `countries_name` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `countries_iso_code_2` char(2) character set latin1 NOT NULL default '',
  `countries_iso_code_3` char(3) character set latin1 NOT NULL default '',
  PRIMARY KEY  (`countries_id`),
  KEY `IDX_COUNTRIES_NAME` (`countries_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=240 ;

-- 
-- Dumping data for table `geo_country_reference`
-- 

INSERT INTO `geo_country_reference` VALUES (1, 'Afghanistan', 'AF', 'AFG');
INSERT INTO `geo_country_reference` VALUES (2, 'Albania', 'AL', 'ALB');
INSERT INTO `geo_country_reference` VALUES (3, 'Algeria', 'DZ', 'DZA');
INSERT INTO `geo_country_reference` VALUES (4, 'American Samoa', 'AS', 'ASM');
INSERT INTO `geo_country_reference` VALUES (5, 'Andorra', 'AD', 'AND');
INSERT INTO `geo_country_reference` VALUES (6, 'Angola', 'AO', 'AGO');
INSERT INTO `geo_country_reference` VALUES (7, 'Anguilla', 'AI', 'AIA');
INSERT INTO `geo_country_reference` VALUES (8, 'Antarctica', 'AQ', 'ATA');
INSERT INTO `geo_country_reference` VALUES (9, 'Antigua and Barbuda', 'AG', 'ATG');
INSERT INTO `geo_country_reference` VALUES (10, 'Argentina', 'AR', 'ARG');
INSERT INTO `geo_country_reference` VALUES (11, 'Armenia', 'AM', 'ARM');
INSERT INTO `geo_country_reference` VALUES (12, 'Aruba', 'AW', 'ABW');
INSERT INTO `geo_country_reference` VALUES (13, 'Australia', 'AU', 'AUS');
INSERT INTO `geo_country_reference` VALUES (14, 'Austria', 'AT', 'AUT');
INSERT INTO `geo_country_reference` VALUES (15, 'Azerbaijan', 'AZ', 'AZE');
INSERT INTO `geo_country_reference` VALUES (16, 'Bahamas', 'BS', 'BHS');
INSERT INTO `geo_country_reference` VALUES (17, 'Bahrain', 'BH', 'BHR');
INSERT INTO `geo_country_reference` VALUES (18, 'Bangladesh', 'BD', 'BGD');
INSERT INTO `geo_country_reference` VALUES (19, 'Barbados', 'BB', 'BRB');
INSERT INTO `geo_country_reference` VALUES (20, 'Belarus', 'BY', 'BLR');
INSERT INTO `geo_country_reference` VALUES (21, 'Belgium', 'BE', 'BEL');
INSERT INTO `geo_country_reference` VALUES (22, 'Belize', 'BZ', 'BLZ');
INSERT INTO `geo_country_reference` VALUES (23, 'Benin', 'BJ', 'BEN');
INSERT INTO `geo_country_reference` VALUES (24, 'Bermuda', 'BM', 'BMU');
INSERT INTO `geo_country_reference` VALUES (25, 'Bhutan', 'BT', 'BTN');
INSERT INTO `geo_country_reference` VALUES (26, 'Bolivia', 'BO', 'BOL');
INSERT INTO `geo_country_reference` VALUES (27, 'Bosnia and Herzegowina', 'BA', 'BIH');
INSERT INTO `geo_country_reference` VALUES (28, 'Botswana', 'BW', 'BWA');
INSERT INTO `geo_country_reference` VALUES (29, 'Bouvet Island', 'BV', 'BVT');
INSERT INTO `geo_country_reference` VALUES (30, 'Brazil', 'BR', 'BRA');
INSERT INTO `geo_country_reference` VALUES (31, 'British Indian Ocean Territory', 'IO', 'IOT');
INSERT INTO `geo_country_reference` VALUES (32, 'Brunei Darussalam', 'BN', 'BRN');
INSERT INTO `geo_country_reference` VALUES (33, 'Bulgaria', 'BG', 'BGR');
INSERT INTO `geo_country_reference` VALUES (34, 'Burkina Faso', 'BF', 'BFA');
INSERT INTO `geo_country_reference` VALUES (35, 'Burundi', 'BI', 'BDI');
INSERT INTO `geo_country_reference` VALUES (36, 'Cambodia', 'KH', 'KHM');
INSERT INTO `geo_country_reference` VALUES (37, 'Cameroon', 'CM', 'CMR');
INSERT INTO `geo_country_reference` VALUES (38, 'Canada', 'CA', 'CAN');
INSERT INTO `geo_country_reference` VALUES (39, 'Cape Verde', 'CV', 'CPV');
INSERT INTO `geo_country_reference` VALUES (40, 'Cayman Islands', 'KY', 'CYM');
INSERT INTO `geo_country_reference` VALUES (41, 'Central African Republic', 'CF', 'CAF');
INSERT INTO `geo_country_reference` VALUES (42, 'Chad', 'TD', 'TCD');
INSERT INTO `geo_country_reference` VALUES (43, 'Chile', 'CL', 'CHL');
INSERT INTO `geo_country_reference` VALUES (44, 'China', 'CN', 'CHN');
INSERT INTO `geo_country_reference` VALUES (45, 'Christmas Island', 'CX', 'CXR');
INSERT INTO `geo_country_reference` VALUES (46, 'Cocos (Keeling) Islands', 'CC', 'CCK');
INSERT INTO `geo_country_reference` VALUES (47, 'Colombia', 'CO', 'COL');
INSERT INTO `geo_country_reference` VALUES (48, 'Comoros', 'KM', 'COM');
INSERT INTO `geo_country_reference` VALUES (49, 'Congo', 'CG', 'COG');
INSERT INTO `geo_country_reference` VALUES (50, 'Cook Islands', 'CK', 'COK');
INSERT INTO `geo_country_reference` VALUES (51, 'Costa Rica', 'CR', 'CRI');
INSERT INTO `geo_country_reference` VALUES (52, 'Cote D Ivoire', 'CI', 'CIV');
INSERT INTO `geo_country_reference` VALUES (53, 'Croatia', 'HR', 'HRV');
INSERT INTO `geo_country_reference` VALUES (54, 'Cuba', 'CU', 'CUB');
INSERT INTO `geo_country_reference` VALUES (55, 'Cyprus', 'CY', 'CYP');
INSERT INTO `geo_country_reference` VALUES (56, 'Czech Republic', 'CZ', 'CZE');
INSERT INTO `geo_country_reference` VALUES (57, 'Denmark', 'DK', 'DNK');
INSERT INTO `geo_country_reference` VALUES (58, 'Djibouti', 'DJ', 'DJI');
INSERT INTO `geo_country_reference` VALUES (59, 'Dominica', 'DM', 'DMA');
INSERT INTO `geo_country_reference` VALUES (60, 'Dominican Republic', 'DO', 'DOM');
INSERT INTO `geo_country_reference` VALUES (61, 'East Timor', 'TP', 'TMP');
INSERT INTO `geo_country_reference` VALUES (62, 'Ecuador', 'EC', 'ECU');
INSERT INTO `geo_country_reference` VALUES (63, 'Egypt', 'EG', 'EGY');
INSERT INTO `geo_country_reference` VALUES (64, 'El Salvador', 'SV', 'SLV');
INSERT INTO `geo_country_reference` VALUES (65, 'Equatorial Guinea', 'GQ', 'GNQ');
INSERT INTO `geo_country_reference` VALUES (66, 'Eritrea', 'ER', 'ERI');
INSERT INTO `geo_country_reference` VALUES (67, 'Estonia', 'EE', 'EST');
INSERT INTO `geo_country_reference` VALUES (68, 'Ethiopia', 'ET', 'ETH');
INSERT INTO `geo_country_reference` VALUES (69, 'Falkland Islands (Malvinas)', 'FK', 'FLK');
INSERT INTO `geo_country_reference` VALUES (70, 'Faroe Islands', 'FO', 'FRO');
INSERT INTO `geo_country_reference` VALUES (71, 'Fiji', 'FJ', 'FJI');
INSERT INTO `geo_country_reference` VALUES (72, 'Finland', 'FI', 'FIN');
INSERT INTO `geo_country_reference` VALUES (73, 'France', 'FR', 'FRA');
INSERT INTO `geo_country_reference` VALUES (74, 'France, MEtropolitan', 'FX', 'FXX');
INSERT INTO `geo_country_reference` VALUES (75, 'French Guiana', 'GF', 'GUF');
INSERT INTO `geo_country_reference` VALUES (76, 'French Polynesia', 'PF', 'PYF');
INSERT INTO `geo_country_reference` VALUES (77, 'French Southern Territories', 'TF', 'ATF');
INSERT INTO `geo_country_reference` VALUES (78, 'Gabon', 'GA', 'GAB');
INSERT INTO `geo_country_reference` VALUES (79, 'Gambia', 'GM', 'GMB');
INSERT INTO `geo_country_reference` VALUES (80, 'Georgia', 'GE', 'GEO');
INSERT INTO `geo_country_reference` VALUES (81, 'Germany', 'DE', 'DEU');
INSERT INTO `geo_country_reference` VALUES (82, 'Ghana', 'GH', 'GHA');
INSERT INTO `geo_country_reference` VALUES (83, 'Gibraltar', 'GI', 'GIB');
INSERT INTO `geo_country_reference` VALUES (84, 'Greece', 'GR', 'GRC');
INSERT INTO `geo_country_reference` VALUES (85, 'Greenland', 'GL', 'GRL');
INSERT INTO `geo_country_reference` VALUES (86, 'Grenada', 'GD', 'GRD');
INSERT INTO `geo_country_reference` VALUES (87, 'Guadeloupe', 'GP', 'GLP');
INSERT INTO `geo_country_reference` VALUES (88, 'Guam', 'GU', 'GUM');
INSERT INTO `geo_country_reference` VALUES (89, 'Guatemala', 'GT', 'GTM');
INSERT INTO `geo_country_reference` VALUES (90, 'Guinea', 'GN', 'GIN');
INSERT INTO `geo_country_reference` VALUES (91, 'Guinea-bissau', 'GW', 'GNB');
INSERT INTO `geo_country_reference` VALUES (92, 'Guyana', 'GY', 'GUY');
INSERT INTO `geo_country_reference` VALUES (93, 'Haiti', 'HT', 'HTI');
INSERT INTO `geo_country_reference` VALUES (94, 'Heard and Mc Donald Islands', 'HM', 'HMD');
INSERT INTO `geo_country_reference` VALUES (95, 'Honduras', 'HN', 'HND');
INSERT INTO `geo_country_reference` VALUES (96, 'Hong Kong', 'HK', 'HKG');
INSERT INTO `geo_country_reference` VALUES (97, 'Hungary', 'HU', 'HUN');
INSERT INTO `geo_country_reference` VALUES (98, 'Iceland', 'IS', 'ISL');
INSERT INTO `geo_country_reference` VALUES (99, 'India', 'IN', 'IND');
INSERT INTO `geo_country_reference` VALUES (100, 'Indonesia', 'ID', 'IDN');
INSERT INTO `geo_country_reference` VALUES (101, 'Iran (Islamic Republic of)', 'IR', 'IRN');
INSERT INTO `geo_country_reference` VALUES (102, 'Iraq', 'IQ', 'IRQ');
INSERT INTO `geo_country_reference` VALUES (103, 'Ireland', 'IE', 'IRL');
INSERT INTO `geo_country_reference` VALUES (104, 'Israel', 'IL', 'ISR');
INSERT INTO `geo_country_reference` VALUES (105, 'Italy', 'IT', 'ITA');
INSERT INTO `geo_country_reference` VALUES (106, 'Jamaica', 'JM', 'JAM');
INSERT INTO `geo_country_reference` VALUES (107, 'Japan', 'JP', 'JPN');
INSERT INTO `geo_country_reference` VALUES (108, 'Jordan', 'JO', 'JOR');
INSERT INTO `geo_country_reference` VALUES (109, 'Kazakhstan', 'KZ', 'KAZ');
INSERT INTO `geo_country_reference` VALUES (110, 'Kenya', 'KE', 'KEN');
INSERT INTO `geo_country_reference` VALUES (111, 'Kiribati', 'KI', 'KIR');
INSERT INTO `geo_country_reference` VALUES (112, 'Korea, Democratic Peoples Republic of', 'KP', 'PRK');
INSERT INTO `geo_country_reference` VALUES (113, 'Korea, Republic of', 'KR', 'KOR');
INSERT INTO `geo_country_reference` VALUES (114, 'Kuwait', 'KW', 'KWT');
INSERT INTO `geo_country_reference` VALUES (115, 'Kyrgyzstan', 'KG', 'KGZ');
INSERT INTO `geo_country_reference` VALUES (116, 'Lao Peoples Democratic Republic', 'LA', 'LAO');
INSERT INTO `geo_country_reference` VALUES (117, 'Latvia', 'LV', 'LVA');
INSERT INTO `geo_country_reference` VALUES (118, 'Lebanon', 'LB', 'LBN');
INSERT INTO `geo_country_reference` VALUES (119, 'Lesotho', 'LS', 'LSO');
INSERT INTO `geo_country_reference` VALUES (120, 'Liberia', 'LR', 'LBR');
INSERT INTO `geo_country_reference` VALUES (121, 'Libyan Arab Jamahiriya', 'LY', 'LBY');
INSERT INTO `geo_country_reference` VALUES (122, 'Liechtenstein', 'LI', 'LIE');
INSERT INTO `geo_country_reference` VALUES (123, 'Lithuania', 'LT', 'LTU');
INSERT INTO `geo_country_reference` VALUES (124, 'Luxembourg', 'LU', 'LUX');
INSERT INTO `geo_country_reference` VALUES (125, 'Macau', 'MO', 'MAC');
INSERT INTO `geo_country_reference` VALUES (126, 'Macedonia, The Former Yugoslav Republic of', 'MK', 'MKD');
INSERT INTO `geo_country_reference` VALUES (127, 'Madagascar', 'MG', 'MDG');
INSERT INTO `geo_country_reference` VALUES (128, 'Malawi', 'MW', 'MWI');
INSERT INTO `geo_country_reference` VALUES (129, 'Malaysia', 'MY', 'MYS');
INSERT INTO `geo_country_reference` VALUES (130, 'Maldives', 'MV', 'MDV');
INSERT INTO `geo_country_reference` VALUES (131, 'Mali', 'ML', 'MLI');
INSERT INTO `geo_country_reference` VALUES (132, 'Malta', 'MT', 'MLT');
INSERT INTO `geo_country_reference` VALUES (133, 'Marshall Islands', 'MH', 'MHL');
INSERT INTO `geo_country_reference` VALUES (134, 'Martinique', 'MQ', 'MTQ');
INSERT INTO `geo_country_reference` VALUES (135, 'Mauritania', 'MR', 'MRT');
INSERT INTO `geo_country_reference` VALUES (136, 'Mauritius', 'MU', 'MUS');
INSERT INTO `geo_country_reference` VALUES (137, 'Mayotte', 'YT', 'MYT');
INSERT INTO `geo_country_reference` VALUES (138, 'Mexico', 'MX', 'MEX');
INSERT INTO `geo_country_reference` VALUES (139, 'Micronesia, Federated States of', 'FM', 'FSM');
INSERT INTO `geo_country_reference` VALUES (140, 'Moldova, Republic of', 'MD', 'MDA');
INSERT INTO `geo_country_reference` VALUES (141, 'Monaco', 'MC', 'MCO');
INSERT INTO `geo_country_reference` VALUES (142, 'Mongolia', 'MN', 'MNG');
INSERT INTO `geo_country_reference` VALUES (143, 'Montserrat', 'MS', 'MSR');
INSERT INTO `geo_country_reference` VALUES (144, 'Morocco', 'MA', 'MAR');
INSERT INTO `geo_country_reference` VALUES (145, 'Mozambique', 'MZ', 'MOZ');
INSERT INTO `geo_country_reference` VALUES (146, 'Myanmar', 'MM', 'MMR');
INSERT INTO `geo_country_reference` VALUES (147, 'Namibia', 'NA', 'NAM');
INSERT INTO `geo_country_reference` VALUES (148, 'Nauru', 'NR', 'NRU');
INSERT INTO `geo_country_reference` VALUES (149, 'Nepal', 'NP', 'NPL');
INSERT INTO `geo_country_reference` VALUES (150, 'Netherlands', 'NL', 'NLD');
INSERT INTO `geo_country_reference` VALUES (151, 'Netherlands Antilles', 'AN', 'ANT');
INSERT INTO `geo_country_reference` VALUES (152, 'New Caledonia', 'NC', 'NCL');
INSERT INTO `geo_country_reference` VALUES (153, 'New Zealand', 'NZ', 'NZL');
INSERT INTO `geo_country_reference` VALUES (154, 'Nicaragua', 'NI', 'NIC');
INSERT INTO `geo_country_reference` VALUES (155, 'Niger', 'NE', 'NER');
INSERT INTO `geo_country_reference` VALUES (156, 'Nigeria', 'NG', 'NGA');
INSERT INTO `geo_country_reference` VALUES (157, 'Niue', 'NU', 'NIU');
INSERT INTO `geo_country_reference` VALUES (158, 'Norfolk Island', 'NF', 'NFK');
INSERT INTO `geo_country_reference` VALUES (159, 'Northern Mariana Islands', 'MP', 'MNP');
INSERT INTO `geo_country_reference` VALUES (160, 'Norway', 'NO', 'NOR');
INSERT INTO `geo_country_reference` VALUES (161, 'Oman', 'OM', 'OMN');
INSERT INTO `geo_country_reference` VALUES (162, 'Pakistan', 'PK', 'PAK');
INSERT INTO `geo_country_reference` VALUES (163, 'Palau', 'PW', 'PLW');
INSERT INTO `geo_country_reference` VALUES (164, 'Panama', 'PA', 'PAN');
INSERT INTO `geo_country_reference` VALUES (165, 'Papua New Guinea', 'PG', 'PNG');
INSERT INTO `geo_country_reference` VALUES (166, 'Paraguay', 'PY', 'PRY');
INSERT INTO `geo_country_reference` VALUES (167, 'Peru', 'PE', 'PER');
INSERT INTO `geo_country_reference` VALUES (168, 'Philippines', 'PH', 'PHL');
INSERT INTO `geo_country_reference` VALUES (169, 'Pitcairn', 'PN', 'PCN');
INSERT INTO `geo_country_reference` VALUES (170, 'Poland', 'PL', 'POL');
INSERT INTO `geo_country_reference` VALUES (171, 'Portugal', 'PT', 'PRT');
INSERT INTO `geo_country_reference` VALUES (172, 'Puerto Rico', 'PR', 'PRI');
INSERT INTO `geo_country_reference` VALUES (173, 'Qatar', 'QA', 'QAT');
INSERT INTO `geo_country_reference` VALUES (174, 'Reunion', 'RE', 'REU');
INSERT INTO `geo_country_reference` VALUES (175, 'Romania', 'RO', 'ROM');
INSERT INTO `geo_country_reference` VALUES (176, 'Russian Federation', 'RU', 'RUS');
INSERT INTO `geo_country_reference` VALUES (177, 'Rwanda', 'RW', 'RWA');
INSERT INTO `geo_country_reference` VALUES (178, 'Saint Kitts and Nevis', 'KN', 'KNA');
INSERT INTO `geo_country_reference` VALUES (179, 'Saint Lucia', 'LC', 'LCA');
INSERT INTO `geo_country_reference` VALUES (180, 'Saint Vincent and the Grenadines', 'VC', 'VCT');
INSERT INTO `geo_country_reference` VALUES (181, 'Samoa', 'WS', 'WSM');
INSERT INTO `geo_country_reference` VALUES (182, 'San Marino', 'SM', 'SMR');
INSERT INTO `geo_country_reference` VALUES (183, 'Sao Tome and Principe', 'ST', 'STP');
INSERT INTO `geo_country_reference` VALUES (184, 'Saudi Arabia', 'SA', 'SAU');
INSERT INTO `geo_country_reference` VALUES (185, 'Senegal', 'SN', 'SEN');
INSERT INTO `geo_country_reference` VALUES (186, 'Seychelles', 'SC', 'SYC');
INSERT INTO `geo_country_reference` VALUES (187, 'Sierra Leone', 'SL', 'SLE');
INSERT INTO `geo_country_reference` VALUES (188, 'Singapore', 'SG', 'SGP');
INSERT INTO `geo_country_reference` VALUES (189, 'Slovakia (Slovak Republic)', 'SK', 'SVK');
INSERT INTO `geo_country_reference` VALUES (190, 'Slovenia', 'SI', 'SVN');
INSERT INTO `geo_country_reference` VALUES (191, 'Solomon Islands', 'SB', 'SLB');
INSERT INTO `geo_country_reference` VALUES (192, 'Somalia', 'SO', 'SOM');
INSERT INTO `geo_country_reference` VALUES (193, 'south Africa', 'ZA', 'ZAF');
INSERT INTO `geo_country_reference` VALUES (194, 'South Georgia and the South Sandwich Islands', 'GS', 'SGS');
INSERT INTO `geo_country_reference` VALUES (195, 'Spain', 'ES', 'ESP');
INSERT INTO `geo_country_reference` VALUES (196, 'Sri Lanka', 'LK', 'LKA');
INSERT INTO `geo_country_reference` VALUES (197, 'St. Helena', 'SH', 'SHN');
INSERT INTO `geo_country_reference` VALUES (198, 'St. Pierre and Miquelon', 'PM', 'SPM');
INSERT INTO `geo_country_reference` VALUES (199, 'Sudan', 'SD', 'SDN');
INSERT INTO `geo_country_reference` VALUES (200, 'Suriname', 'SR', 'SUR');
INSERT INTO `geo_country_reference` VALUES (201, 'Svalbard and Jan Mayen Islands', 'SJ', 'SJM');
INSERT INTO `geo_country_reference` VALUES (202, 'Swaziland', 'SZ', 'SWZ');
INSERT INTO `geo_country_reference` VALUES (203, 'Sweden', 'SE', 'SWE');
INSERT INTO `geo_country_reference` VALUES (204, 'Switzerland', 'CH', 'CHE');
INSERT INTO `geo_country_reference` VALUES (205, 'Syrian Arab Republic', 'SY', 'SYR');
INSERT INTO `geo_country_reference` VALUES (206, 'Taiwan, Province of China', 'TW', 'TWN');
INSERT INTO `geo_country_reference` VALUES (207, 'Tajikistan', 'TJ', 'TJK');
INSERT INTO `geo_country_reference` VALUES (208, 'Tanzania, United Republic of', 'TZ', 'TZA');
INSERT INTO `geo_country_reference` VALUES (209, 'Thailand', 'TH', 'THA');
INSERT INTO `geo_country_reference` VALUES (210, 'Togo', 'TG', 'TGO');
INSERT INTO `geo_country_reference` VALUES (211, 'Tokelau', 'TK', 'TKL');
INSERT INTO `geo_country_reference` VALUES (212, 'Tonga', 'TO', 'TON');
INSERT INTO `geo_country_reference` VALUES (213, 'Trinidad and Tobago', 'TT', 'TTO');
INSERT INTO `geo_country_reference` VALUES (214, 'Tunisia', 'TN', 'TUN');
INSERT INTO `geo_country_reference` VALUES (215, 'Turkey', 'TR', 'TUR');
INSERT INTO `geo_country_reference` VALUES (216, 'Turkmenistan', 'TM', 'TKM');
INSERT INTO `geo_country_reference` VALUES (217, 'Turks and Caicos Islands', 'TC', 'TCA');
INSERT INTO `geo_country_reference` VALUES (218, 'Tuvalu', 'TV', 'TUV');
INSERT INTO `geo_country_reference` VALUES (219, 'Uganda', 'UG', 'UGA');
INSERT INTO `geo_country_reference` VALUES (220, 'Ukraine', 'UA', 'UKR');
INSERT INTO `geo_country_reference` VALUES (221, 'United Arab Emirates', 'AE', 'ARE');
INSERT INTO `geo_country_reference` VALUES (222, 'United Kingdom', 'GB', 'GBR');
INSERT INTO `geo_country_reference` VALUES (223, 'United States', 'US', 'USA');
INSERT INTO `geo_country_reference` VALUES (224, 'United States Minor Outlying Islands', 'UM', 'UMI');
INSERT INTO `geo_country_reference` VALUES (225, 'Uruguay', 'UY', 'URY');
INSERT INTO `geo_country_reference` VALUES (226, 'Uzbekistan', 'UZ', 'UZB');
INSERT INTO `geo_country_reference` VALUES (227, 'Vanuatu', 'VU', 'VUT');
INSERT INTO `geo_country_reference` VALUES (228, 'Vatican City State (Holy See)', 'VA', 'VAT');
INSERT INTO `geo_country_reference` VALUES (229, 'Venezuela', 'VE', 'VEN');
INSERT INTO `geo_country_reference` VALUES (230, 'Viet Nam', 'VN', 'VNM');
INSERT INTO `geo_country_reference` VALUES (231, 'Virgin Islands (British)', 'VG', 'VGB');
INSERT INTO `geo_country_reference` VALUES (232, 'Virgin Islands (U.S.)', 'VI', 'VIR');
INSERT INTO `geo_country_reference` VALUES (233, 'Wallis and Futuna Islands', 'WF', 'WLF');
INSERT INTO `geo_country_reference` VALUES (234, 'Western Sahara', 'EH', 'ESH');
INSERT INTO `geo_country_reference` VALUES (235, 'Yemen', 'YE', 'YEM');
INSERT INTO `geo_country_reference` VALUES (236, 'Yugoslavia', 'YU', 'YUG');
INSERT INTO `geo_country_reference` VALUES (237, 'Zaire', 'ZR', 'ZAR');
INSERT INTO `geo_country_reference` VALUES (238, 'Zambia', 'ZM', 'ZMB');
INSERT INTO `geo_country_reference` VALUES (239, 'Zimbabwe', 'ZW', 'ZWE');

-- --------------------------------------------------------

-- 
-- Table structure for table `geo_zone_reference`
-- 

DROP TABLE IF EXISTS `geo_zone_reference`;
CREATE TABLE `geo_zone_reference` (
  `zone_id` int(5) NOT NULL auto_increment,
  `zone_country_id` int(5) NOT NULL default '0',
  `zone_code` varchar(5) character set utf8 collate utf8_unicode_ci default NULL,
  `zone_name` varchar(32) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`zone_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=83 ;

-- 
-- Dumping data for table `geo_zone_reference`
-- 

INSERT INTO `geo_zone_reference` VALUES (1, 223, 'AL', 'Alabama');
INSERT INTO `geo_zone_reference` VALUES (2, 223, 'AK', 'Alaska');
INSERT INTO `geo_zone_reference` VALUES (3, 223, 'AS', 'American Samoa');
INSERT INTO `geo_zone_reference` VALUES (4, 223, 'AZ', 'Arizona');
INSERT INTO `geo_zone_reference` VALUES (5, 223, 'AR', 'Arkansas');
INSERT INTO `geo_zone_reference` VALUES (6, 223, 'AF', 'Armed Forces Africa');
INSERT INTO `geo_zone_reference` VALUES (7, 223, 'AA', 'Armed Forces Americas');
INSERT INTO `geo_zone_reference` VALUES (8, 223, 'AC', 'Armed Forces Canada');
INSERT INTO `geo_zone_reference` VALUES (9, 223, 'AE', 'Armed Forces Europe');
INSERT INTO `geo_zone_reference` VALUES (10, 223, 'AM', 'Armed Forces Middle East');
INSERT INTO `geo_zone_reference` VALUES (11, 223, 'AP', 'Armed Forces Pacific');
INSERT INTO `geo_zone_reference` VALUES (12, 223, 'CA', 'California');
INSERT INTO `geo_zone_reference` VALUES (13, 223, 'CO', 'Colorado');
INSERT INTO `geo_zone_reference` VALUES (14, 223, 'CT', 'Connecticut');
INSERT INTO `geo_zone_reference` VALUES (15, 223, 'DE', 'Delaware');
INSERT INTO `geo_zone_reference` VALUES (16, 223, 'DC', 'District of Columbia');
INSERT INTO `geo_zone_reference` VALUES (17, 223, 'FM', 'Federated States Of Micronesia');
INSERT INTO `geo_zone_reference` VALUES (18, 223, 'FL', 'Florida');
INSERT INTO `geo_zone_reference` VALUES (19, 223, 'GA', 'Georgia');
INSERT INTO `geo_zone_reference` VALUES (20, 223, 'GU', 'Guam');
INSERT INTO `geo_zone_reference` VALUES (21, 223, 'HI', 'Hawaii');
INSERT INTO `geo_zone_reference` VALUES (22, 223, 'ID', 'Idaho');
INSERT INTO `geo_zone_reference` VALUES (23, 223, 'IL', 'Illinois');
INSERT INTO `geo_zone_reference` VALUES (24, 223, 'IN', 'Indiana');
INSERT INTO `geo_zone_reference` VALUES (25, 223, 'IA', 'Iowa');
INSERT INTO `geo_zone_reference` VALUES (26, 223, 'KS', 'Kansas');
INSERT INTO `geo_zone_reference` VALUES (27, 223, 'KY', 'Kentucky');
INSERT INTO `geo_zone_reference` VALUES (28, 223, 'LA', 'Louisiana');
INSERT INTO `geo_zone_reference` VALUES (29, 223, 'ME', 'Maine');
INSERT INTO `geo_zone_reference` VALUES (30, 223, 'MH', 'Marshall Islands');
INSERT INTO `geo_zone_reference` VALUES (31, 223, 'MD', 'Maryland');
INSERT INTO `geo_zone_reference` VALUES (32, 223, 'MA', 'Massachusetts');
INSERT INTO `geo_zone_reference` VALUES (33, 223, 'MI', 'Michigan');
INSERT INTO `geo_zone_reference` VALUES (34, 223, 'MN', 'Minnesota');
INSERT INTO `geo_zone_reference` VALUES (35, 223, 'MS', 'Mississippi');
INSERT INTO `geo_zone_reference` VALUES (36, 223, 'MO', 'Missouri');
INSERT INTO `geo_zone_reference` VALUES (37, 223, 'MT', 'Montana');
INSERT INTO `geo_zone_reference` VALUES (38, 223, 'NE', 'Nebraska');
INSERT INTO `geo_zone_reference` VALUES (39, 223, 'NV', 'Nevada');
INSERT INTO `geo_zone_reference` VALUES (40, 223, 'NH', 'New Hampshire');
INSERT INTO `geo_zone_reference` VALUES (41, 223, 'NJ', 'New Jersey');
INSERT INTO `geo_zone_reference` VALUES (42, 223, 'NM', 'New Mexico');
INSERT INTO `geo_zone_reference` VALUES (43, 223, 'NY', 'New York');
INSERT INTO `geo_zone_reference` VALUES (44, 223, 'NC', 'North Carolina');
INSERT INTO `geo_zone_reference` VALUES (45, 223, 'ND', 'North Dakota');
INSERT INTO `geo_zone_reference` VALUES (46, 223, 'MP', 'Northern Mariana Islands');
INSERT INTO `geo_zone_reference` VALUES (47, 223, 'OH', 'Ohio');
INSERT INTO `geo_zone_reference` VALUES (48, 223, 'OK', 'Oklahoma');
INSERT INTO `geo_zone_reference` VALUES (49, 223, 'OR', 'Oregon');
INSERT INTO `geo_zone_reference` VALUES (50, 223, 'PW', 'Palau');
INSERT INTO `geo_zone_reference` VALUES (51, 223, 'PA', 'Pennsylvania');
INSERT INTO `geo_zone_reference` VALUES (52, 223, 'PR', 'Puerto Rico');
INSERT INTO `geo_zone_reference` VALUES (53, 223, 'RI', 'Rhode Island');
INSERT INTO `geo_zone_reference` VALUES (54, 223, 'SC', 'South Carolina');
INSERT INTO `geo_zone_reference` VALUES (55, 223, 'SD', 'South Dakota');
INSERT INTO `geo_zone_reference` VALUES (56, 223, 'TN', 'Tenessee');
INSERT INTO `geo_zone_reference` VALUES (57, 223, 'TX', 'Texas');
INSERT INTO `geo_zone_reference` VALUES (58, 223, 'UT', 'Utah');
INSERT INTO `geo_zone_reference` VALUES (59, 223, 'VT', 'Vermont');
INSERT INTO `geo_zone_reference` VALUES (60, 223, 'VI', 'Virgin Islands');
INSERT INTO `geo_zone_reference` VALUES (61, 223, 'VA', 'Virginia');
INSERT INTO `geo_zone_reference` VALUES (62, 223, 'WA', 'Washington');
INSERT INTO `geo_zone_reference` VALUES (63, 223, 'WV', 'West Virginia');
INSERT INTO `geo_zone_reference` VALUES (64, 223, 'WI', 'Wisconsin');
INSERT INTO `geo_zone_reference` VALUES (65, 223, 'WY', 'Wyoming');
INSERT INTO `geo_zone_reference` VALUES (66, 38, 'AB', 'Alberta');
INSERT INTO `geo_zone_reference` VALUES (67, 38, 'BC', 'British Columbia');
INSERT INTO `geo_zone_reference` VALUES (68, 38, 'MB', 'Manitoba');
INSERT INTO `geo_zone_reference` VALUES (69, 38, 'NF', 'Newfoundland');
INSERT INTO `geo_zone_reference` VALUES (70, 38, 'NB', 'New Brunswick');
INSERT INTO `geo_zone_reference` VALUES (71, 38, 'NS', 'Nova Scotia');
INSERT INTO `geo_zone_reference` VALUES (72, 38, 'NT', 'Northwest Territories');
INSERT INTO `geo_zone_reference` VALUES (73, 38, 'NU', 'Nunavut');
INSERT INTO `geo_zone_reference` VALUES (74, 38, 'ON', 'Ontario');
INSERT INTO `geo_zone_reference` VALUES (75, 38, 'PE', 'Prince Edward Island');
INSERT INTO `geo_zone_reference` VALUES (76, 38, 'QC', 'Quebec');
INSERT INTO `geo_zone_reference` VALUES (77, 38, 'SK', 'Saskatchewan');
INSERT INTO `geo_zone_reference` VALUES (78, 38, 'YT', 'Yukon Territory');
INSERT INTO `geo_zone_reference` VALUES (79, 61, 'QLD', 'Queensland');
INSERT INTO `geo_zone_reference` VALUES (80, 61, 'SA', 'South Australia');
INSERT INTO `geo_zone_reference` VALUES (81, 61, 'ACT', 'Australian Capital Territory');
INSERT INTO `geo_zone_reference` VALUES (82, 61, 'VIC', 'Victoria');

-- --------------------------------------------------------

-- 
-- Table structure for table `groups`
-- 

DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `id` bigint(20) NOT NULL auto_increment,
  `name` longtext character set utf8 collate utf8_unicode_ci,
  `user` longtext character set utf8 collate utf8_unicode_ci,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `history_data`
-- 

DROP TABLE IF EXISTS `history_data`;
CREATE TABLE `history_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `coffee` longtext character set utf8 collate utf8_unicode_ci,
  `tobacco` longtext character set utf8 collate utf8_unicode_ci,
  `alcohol` longtext character set utf8 collate utf8_unicode_ci,
  `sleep_patterns` longtext character set utf8 collate utf8_unicode_ci,
  `exercise_patterns` longtext character set utf8 collate utf8_unicode_ci,
  `seatbelt_use` longtext character set utf8 collate utf8_unicode_ci,
  `counseling` longtext character set utf8 collate utf8_unicode_ci,
  `hazardous_activities` longtext character set utf8 collate utf8_unicode_ci,
  `last_breast_exam` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_mammogram` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_gynocological_exam` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_rectal_exam` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_prostate_exam` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_physical_exam` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_sigmoidoscopy_colonoscopy` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_ecg` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_cardiac_echo` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_retinal` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_fluvax` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_pneuvax` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_ldl` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_hemoglobin` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_psa` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `last_exam_results` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `history_mother` longtext character set utf8 collate utf8_unicode_ci,
  `history_father` longtext character set utf8 collate utf8_unicode_ci,
  `history_siblings` longtext character set utf8 collate utf8_unicode_ci,
  `history_offspring` longtext character set utf8 collate utf8_unicode_ci,
  `history_spouse` longtext character set utf8 collate utf8_unicode_ci,
  `relatives_cancer` longtext character set utf8 collate utf8_unicode_ci,
  `relatives_tuberculosis` longtext character set utf8 collate utf8_unicode_ci,
  `relatives_diabetes` longtext character set utf8 collate utf8_unicode_ci,
  `relatives_high_blood_pressure` longtext character set utf8 collate utf8_unicode_ci,
  `relatives_heart_problems` longtext character set utf8 collate utf8_unicode_ci,
  `relatives_stroke` longtext character set utf8 collate utf8_unicode_ci,
  `relatives_epilepsy` longtext character set utf8 collate utf8_unicode_ci,
  `relatives_mental_illness` longtext character set utf8 collate utf8_unicode_ci,
  `relatives_suicide` longtext character set utf8 collate utf8_unicode_ci,
  `cataract_surgery` datetime default NULL,
  `tonsillectomy` datetime default NULL,
  `cholecystestomy` datetime default NULL,
  `heart_surgery` datetime default NULL,
  `hysterectomy` datetime default NULL,
  `hernia_repair` datetime default NULL,
  `hip_replacement` datetime default NULL,
  `knee_replacement` datetime default NULL,
  `appendectomy` datetime default NULL,
  `date` datetime default NULL,
  `pid` bigint(20) NOT NULL default '0',
  `name_1` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `value_1` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `name_2` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `value_2` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `additional_history` text character set utf8 collate utf8_unicode_ci,
  `exams`      text         character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext11` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext12` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext13` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext14` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext15` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext16` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext17` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext18` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext19` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext20` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext21` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext22` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext23` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext24` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext25` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext26` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext27` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext28` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext29` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext30` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `userdate11` date DEFAULT NULL,
  `userdate12` date DEFAULT NULL,
  `userdate13` date DEFAULT NULL,
  `userdate14` date DEFAULT NULL,
  `userdate15` date DEFAULT NULL,
  `userarea11` text character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `userarea12` text character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `immunization`
-- 

DROP TABLE IF EXISTS `immunization`;
CREATE TABLE `immunization` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`),
  KEY `immunization_name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=36 ;

-- 
-- Dumping data for table `immunization`
-- 

INSERT INTO `immunization` VALUES (1, 'DTaP 1');
INSERT INTO `immunization` VALUES (2, 'DTaP 2');
INSERT INTO `immunization` VALUES (3, 'DTaP 3');
INSERT INTO `immunization` VALUES (4, 'DTaP 4');
INSERT INTO `immunization` VALUES (5, 'DTaP 5');
INSERT INTO `immunization` VALUES (6, 'DT 1');
INSERT INTO `immunization` VALUES (7, 'DT 2');
INSERT INTO `immunization` VALUES (8, 'DT 3');
INSERT INTO `immunization` VALUES (9, 'DT 4');
INSERT INTO `immunization` VALUES (10, 'DT 5');
INSERT INTO `immunization` VALUES (11, 'IPV 1');
INSERT INTO `immunization` VALUES (12, 'IPV 2');
INSERT INTO `immunization` VALUES (13, 'IPV 3');
INSERT INTO `immunization` VALUES (14, 'IPV 4');
INSERT INTO `immunization` VALUES (15, 'Hib 1');
INSERT INTO `immunization` VALUES (16, 'Hib 2');
INSERT INTO `immunization` VALUES (17, 'Hib 3');
INSERT INTO `immunization` VALUES (18, 'Hib 4');
INSERT INTO `immunization` VALUES (19, 'Pneumococcal Conjugate 1');
INSERT INTO `immunization` VALUES (20, 'Pneumococcal Conjugate 2');
INSERT INTO `immunization` VALUES (21, 'Pneumococcal Conjugate 3');
INSERT INTO `immunization` VALUES (22, 'Pneumococcal Conjugate 4');
INSERT INTO `immunization` VALUES (23, 'MMR 1');
INSERT INTO `immunization` VALUES (24, 'MMR 2');
INSERT INTO `immunization` VALUES (25, 'Varicella 1');
INSERT INTO `immunization` VALUES (26, 'Varicella 2');
INSERT INTO `immunization` VALUES (27, 'Hepatitis B 1');
INSERT INTO `immunization` VALUES (28, 'Hepatitis B 2');
INSERT INTO `immunization` VALUES (29, 'Hepatitis B 3');
INSERT INTO `immunization` VALUES (30, 'Influenza 1');
INSERT INTO `immunization` VALUES (31, 'Influenza 2');
INSERT INTO `immunization` VALUES (32, 'Td');
INSERT INTO `immunization` VALUES (33, 'Hepatitis A 1');
INSERT INTO `immunization` VALUES (34, 'Hepatitis A 2');
INSERT INTO `immunization` VALUES (35, 'Other');

-- --------------------------------------------------------

-- 
-- Table structure for table `immunizations`
-- 

DROP TABLE IF EXISTS `immunizations`;
CREATE TABLE `immunizations` (
  `id` bigint(20) NOT NULL auto_increment,
  `patient_id` int(11) default NULL,
  `administered_date` date default NULL,
  `immunization_id` int(11) default NULL,
  `manufacturer` varchar(100) character set utf8 collate utf8_unicode_ci default NULL,
  `lot_number` varchar(50) character set utf8 collate utf8_unicode_ci default NULL,
  `administered_by_id` bigint(20) default NULL,
  `education_date` date default NULL,
  `note` text character set utf8 collate utf8_unicode_ci,
  `create_date` datetime default NULL,
  `update_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `created_by` bigint(20) default NULL,
  `updated_by` bigint(20) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `insurance_companies`
-- 

DROP TABLE IF EXISTS `insurance_companies`;
CREATE TABLE `insurance_companies` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `attn` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `cms_id` varchar(15) character set utf8 collate utf8_unicode_ci default NULL,
  `freeb_type` tinyint(2) default NULL,
  `x12_receiver_id` varchar(25) character set utf8 collate utf8_unicode_ci default NULL,
  `x12_default_partner_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `insurance_data`
-- 

DROP TABLE IF EXISTS `insurance_data`;
CREATE TABLE `insurance_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `type` enum('primary','secondary','tertiary') character set latin1 default NULL,
  `provider` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `plan_name` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `policy_number` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `group_number` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_lname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_mname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_fname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_relationship` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_ss` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_DOB` date default NULL,
  `subscriber_street` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_postal_code` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_city` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_state` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_country` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_phone` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_employer` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_employer_street` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_employer_postal_code` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_employer_state` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_employer_country` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `subscriber_employer_city` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `copay` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `date` date NOT NULL default '0000-00-00',
  `pid` bigint(20) NOT NULL default '0',
  `subscriber_sex` varchar(25) character set utf8 collate utf8_unicode_ci default NULL,
  `accept_assignment` varchar(5) NOT NULL DEFAULT 'TRUE',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `pid_type_date` (`pid`,`type`,`date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `insurance_numbers`
-- 

DROP TABLE IF EXISTS `insurance_numbers`;
CREATE TABLE `insurance_numbers` (
  `id` int(11) NOT NULL default '0',
  `provider_id` int(11) NOT NULL default '0',
  `insurance_company_id` int(11) default NULL,
  `provider_number` varchar(20) character set utf8 collate utf8_unicode_ci default NULL,
  `rendering_provider_number` varchar(20) character set utf8 collate utf8_unicode_ci default NULL,
  `group_number` varchar(20) character set utf8 collate utf8_unicode_ci default NULL,
  `provider_number_type` varchar(4) character set utf8 collate utf8_unicode_ci default NULL,
  `rendering_provider_number_type` varchar(4) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `integration_mapping`
-- 

DROP TABLE IF EXISTS `integration_mapping`;
CREATE TABLE `integration_mapping` (
  `id` int(11) NOT NULL default '0',
  `foreign_id` int(11) NOT NULL default '0',
  `foreign_table` varchar(125) character set utf8 collate utf8_unicode_ci default NULL,
  `local_id` int(11) NOT NULL default '0',
  `local_table` varchar(125) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `foreign_id` (`foreign_id`,`foreign_table`,`local_id`,`local_table`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `issue_encounter`
-- 

DROP TABLE IF EXISTS `issue_encounter`;
CREATE TABLE `issue_encounter` (
  `pid` int(11) NOT NULL,
  `list_id` int(11) NOT NULL,
  `encounter` int(11) NOT NULL,
  `resolved` tinyint(1) NOT NULL,
  PRIMARY KEY  (`pid`,`list_id`,`encounter`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `lang_constants`
-- 

DROP TABLE IF EXISTS `lang_constants`;
CREATE TABLE `lang_constants` (
  `cons_id` int(11) NOT NULL auto_increment,
  `constant_name` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  UNIQUE KEY `cons_id` (`cons_id`),
  KEY `cons_name` (`constant_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin ;

-- 
-- Table structure for table `lang_definitions`
-- 

DROP TABLE IF EXISTS `lang_definitions`;
CREATE TABLE `lang_definitions` (
  `def_id` int(11) NOT NULL auto_increment,
  `cons_id` int(11) NOT NULL default '0',
  `lang_id` int(11) NOT NULL default '0',
  `definition` mediumtext character set utf8 collate utf8_unicode_ci,
  UNIQUE KEY `def_id` (`def_id`),
  KEY `definition` (`definition`(100))
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin ;

-- 
-- Table structure for table `lang_languages`
-- 

DROP TABLE IF EXISTS `lang_languages`;
CREATE TABLE `lang_languages` (
  `lang_id` int(11) NOT NULL auto_increment,
  `lang_code` char(2) character set latin1 NOT NULL default '',
  `lang_description` varchar(100) character set utf8 collate utf8_unicode_ci default NULL,
  UNIQUE KEY `lang_id` (`lang_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=7 ;

-- 
-- Dumping data for table `lang_languages`
-- 

INSERT INTO `lang_languages` VALUES (1, 'en', 'English');
INSERT INTO `lang_languages` VALUES (2, 'se', 'Swedish');
INSERT INTO `lang_languages` VALUES (3, 'es', 'Spanish');
INSERT INTO `lang_languages` VALUES (4, 'de', 'German');
INSERT INTO `lang_languages` VALUES (5, 'du', 'Dutch');
INSERT INTO `lang_languages` VALUES (6, 'he', 'Hebrew');

-- --------------------------------------------------------

-- 
-- Table structure for table `layout_options`
-- 

DROP TABLE IF EXISTS `layout_options`;
CREATE TABLE `layout_options` (
  `form_id` varchar(31) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `field_id` varchar(31) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `group_name` varchar(31) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `title` varchar(63) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `seq` int(11) NOT NULL default '0',
  `data_type` tinyint(3) NOT NULL default '0',
  `uor` tinyint(1) NOT NULL default '1',
  `fld_length` int(11) NOT NULL default '15',
  `max_length` int(11) NOT NULL default '0',
  `list_id` varchar(31) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `titlecols` tinyint(3) NOT NULL default '1',
  `datacols` tinyint(3) NOT NULL default '1',
  `default_value` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `edit_options` varchar(36) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `description` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  PRIMARY KEY  (`form_id`,`field_id`,`seq`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 
-- Dumping data for table `layout_options`
-- 

INSERT INTO `layout_options` VALUES ('DEM', 'title', '1Who', 'Name', 1, 1, 1, 0, 0, 'titles', 1, 1, '', '', 'Title');
INSERT INTO `layout_options` VALUES ('DEM', 'fname', '1Who', '', 2, 2, 2, 10, 63, '', 0, 0, '', 'C', 'First Name');
INSERT INTO `layout_options` VALUES ('DEM', 'mname', '1Who', '', 3, 2, 1, 2, 63, '', 0, 0, '', 'C', 'Middle Name');
INSERT INTO `layout_options` VALUES ('DEM', 'lname', '1Who', '', 4, 2, 2, 10, 63, '', 0, 0, '', 'C', 'Last Name');
INSERT INTO `layout_options` VALUES ('DEM', 'pubpid', '1Who', 'External ID', 5, 2, 1, 10, 15, '', 1, 1, '', '', 'External identifier');
INSERT INTO `layout_options` VALUES ('DEM', 'DOB', '1Who', 'DOB', 6, 4, 2, 10, 10, '', 1, 1, '', 'D', 'Date of Birth');
INSERT INTO `layout_options` VALUES ('DEM', 'sex', '1Who', 'Sex', 7, 1, 2, 0, 0, 'sex', 1, 1, '', '', 'Sex');
INSERT INTO `layout_options` VALUES ('DEM', 'ss', '1Who', 'S.S.', 8, 2, 1, 11, 11, '', 1, 1, '', '', 'Social Security Number');
INSERT INTO `layout_options` VALUES ('DEM', 'drivers_license', '1Who', 'License/ID', 9, 2, 1, 15, 63, '', 1, 1, '', '', 'Drivers License or State ID');
INSERT INTO `layout_options` VALUES ('DEM', 'status', '1Who', 'Marital Status', 10, 1, 1, 0, 0, 'marital', 1, 3, '', '', 'Marital Status');
INSERT INTO `layout_options` VALUES ('DEM', 'genericname1', '1Who', 'User Defined', 11, 2, 1, 15, 63, '', 1, 3, '', '', 'User Defined Field');
INSERT INTO `layout_options` VALUES ('DEM', 'genericval1', '1Who', '', 12, 2, 1, 15, 63, '', 0, 0, '', '', 'User Defined Field');
INSERT INTO `layout_options` VALUES ('DEM', 'genericname2', '1Who', '', 13, 2, 1, 15, 63, '', 0, 0, '', '', 'User Defined Field');
INSERT INTO `layout_options` VALUES ('DEM', 'genericval2', '1Who', '', 14, 2, 1, 15, 63, '', 0, 0, '', '', 'User Defined Field');
INSERT INTO `layout_options` VALUES ('DEM', 'squad', '1Who', 'Squad', 15, 13, 0, 0, 0, '', 1, 3, '', '', 'Squad Membership');
INSERT INTO `layout_options` VALUES ('DEM', 'pricelevel', '1Who', 'Price Level', 16, 1, 0, 0, 0, 'pricelevel', 1, 1, '', '', 'Discount Level');
INSERT INTO `layout_options` VALUES ('DEM', 'street', '2Contact', 'Address', 1, 2, 1, 25, 63, '', 1, 1, '', 'C', 'Street and Number');
INSERT INTO `layout_options` VALUES ('DEM', 'city', '2Contact', 'City', 2, 2, 1, 15, 63, '', 1, 1, '', 'C', 'City Name');
INSERT INTO `layout_options` VALUES ('DEM', 'state', '2Contact', 'State', 3, 1, 1, 0, 0, 'state', 1, 1, '', '', 'State/Locality');
INSERT INTO `layout_options` VALUES ('DEM', 'postal_code', '2Contact', 'Postal Code', 4, 2, 1, 6, 63, '', 1, 1, '', '', 'Postal Code');
INSERT INTO `layout_options` VALUES ('DEM', 'country_code', '2Contact', 'Country', 5, 1, 1, 0, 0, 'country', 1, 1, '', '', 'Country');
INSERT INTO `layout_options` VALUES ('DEM', 'contact_relationship', '2Contact', 'Emergency Contact', 6, 2, 1, 10, 63, '', 1, 1, '', 'C', 'Emergency Contact Person');
INSERT INTO `layout_options` VALUES ('DEM', 'phone_contact', '2Contact', 'Emergency Phone', 7, 2, 1, 20, 63, '', 1, 1, '', 'P', 'Emergency Contact Phone Number');
INSERT INTO `layout_options` VALUES ('DEM', 'phone_home', '2Contact', 'Home Phone', 8, 2, 1, 20, 63, '', 1, 1, '', 'P', 'Home Phone Number');
INSERT INTO `layout_options` VALUES ('DEM', 'phone_biz', '2Contact', 'Work Phone', 9, 2, 1, 20, 63, '', 1, 1, '', 'P', 'Work Phone Number');
INSERT INTO `layout_options` VALUES ('DEM', 'phone_cell', '2Contact', 'Mobile Phone', 10, 2, 1, 20, 63, '', 1, 1, '', 'P', 'Cell Phone Number');
INSERT INTO `layout_options` VALUES ('DEM', 'email', '2Contact', 'Contact Email', 11, 2, 1, 30, 95, '', 1, 1, '', '', 'Contact Email Address');
INSERT INTO `layout_options` VALUES ('DEM', 'providerID', '3Choices', 'Provider', 1, 11, 2, 0, 0, '', 1, 3, '', '', 'Referring Provider');
INSERT INTO `layout_options` VALUES ('DEM', 'pharmacy_id', '3Choices', 'Pharmacy', 2, 12, 1, 0, 0, '', 1, 3, '', '', 'Preferred Pharmacy');
INSERT INTO `layout_options` VALUES ('DEM', 'hipaa_notice', '3Choices', 'HIPAA Notice Received', 3, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Did you receive a copy of the HIPAA Notice?');
INSERT INTO `layout_options` VALUES ('DEM', 'hipaa_voice', '3Choices', 'Allow Voice Message', 4, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Allow telephone messages?');
INSERT INTO `layout_options` VALUES ('DEM', 'hipaa_mail', '3Choices', 'Allow Mail Message', 5, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Allow email messages?');
INSERT INTO `layout_options` VALUES ('DEM', 'hipaa_message', '3Choices', 'Leave Message With', 6, 2, 1, 20, 63, '', 1, 1, '', '', 'With whom may we leave a message?');
INSERT INTO `layout_options` VALUES ('DEM', 'occupation', '4Employer', 'Occupation', 1, 2, 1, 20, 63, '', 1, 1, '', 'C', 'Occupation');
INSERT INTO `layout_options` VALUES ('DEM', 'em_name', '4Employer', 'Employer Name', 2, 2, 1, 20, 63, '', 1, 1, '', 'C', 'Employer Name');
INSERT INTO `layout_options` VALUES ('DEM', 'em_street', '4Employer', 'Employer Address', 3, 2, 1, 25, 63, '', 1, 1, '', 'C', 'Street and Number');
INSERT INTO `layout_options` VALUES ('DEM', 'em_city', '4Employer', 'City', 4, 2, 1, 15, 63, '', 1, 1, '', 'C', 'City Name');
INSERT INTO `layout_options` VALUES ('DEM', 'em_state', '4Employer', 'State', 5, 2, 1, 15, 63, '', 1, 1, '', 'C', 'State/Locality');
INSERT INTO `layout_options` VALUES ('DEM', 'em_postal_code', '4Employer', 'Postal Code', 6, 2, 1, 6, 63, '', 1, 1, '', '', 'Postal Code');
INSERT INTO `layout_options` VALUES ('DEM', 'em_country', '4Employer', 'Country', 7, 2, 1, 10, 63, '', 1, 1, '', 'C', 'Country');
INSERT INTO `layout_options` VALUES ('DEM', 'language', '5Stats', 'Language', 1, 1, 1, 0, 0, 'language', 1, 1, '', '', 'Preferred Language');
INSERT INTO `layout_options` VALUES ('DEM', 'ethnoracial', '5Stats', 'Race/Ethnicity', 2, 1, 1, 0, 0, 'ethrace', 1, 1, '', '', 'Ethnicity or Race');
INSERT INTO `layout_options` VALUES ('DEM', 'financial_review', '5Stats', 'Financial Review Date', 3, 2, 1, 10, 10, '', 1, 1, '', 'D', 'Financial Review Date');
INSERT INTO `layout_options` VALUES ('DEM', 'family_size', '5Stats', 'Family Size', 4, 2, 1, 20, 63, '', 1, 1, '', '', 'Family Size');
INSERT INTO `layout_options` VALUES ('DEM', 'monthly_income', '5Stats', 'Monthly Income', 5, 2, 1, 20, 63, '', 1, 1, '', '', 'Monthly Income');
INSERT INTO `layout_options` VALUES ('DEM', 'homeless', '5Stats', 'Homeless, etc.', 6, 2, 1, 20, 63, '', 1, 1, '', '', 'Homeless or similar?');
INSERT INTO `layout_options` VALUES ('DEM', 'interpretter', '5Stats', 'Interpreter', 7, 2, 1, 20, 63, '', 1, 1, '', '', 'Interpreter needed?');
INSERT INTO `layout_options` VALUES ('DEM', 'migrantseasonal', '5Stats', 'Migrant/Seasonal', 8, 2, 1, 20, 63, '', 1, 1, '', '', 'Migrant or seasonal worker?');
INSERT INTO `layout_options` VALUES ('DEM', 'contrastart', '5Stats', 'Contraceptives Start',9,4,0,10,10,'',1,1,'','','Date contraceptive services initially provided');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext1', '6Misc', 'User Defined Text 1', 1, 2, 0, 10, 63, '', 1, 1, '', '', 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext2', '6Misc', 'User Defined Text 2', 2, 2, 0, 10, 63, '', 1, 1, '', '', 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext3', '6Misc', 'User Defined Text 3', 3,2,0,10,63,'',1,1,'','','User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext4', '6Misc', 'User Defined Text 4', 4,2,0,10,63,'',1,1,'','','User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext5', '6Misc', 'User Defined Text 5', 5,2,0,10,63,'',1,1,'','','User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext6', '6Misc', 'User Defined Text 6', 6,2,0,10,63,'',1,1,'','','User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext7', '6Misc', 'User Defined Text 7', 7,2,0,10,63,'',1,1,'','','User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'usertext8', '6Misc', 'User Defined Text 8', 8,2,0,10,63,'',1,1,'','','User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist1', '6Misc', 'User Defined List 1', 9, 1, 0, 0, 0, 'userlist1', 1, 1, '', '', 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist2', '6Misc', 'User Defined List 2',10, 1, 0, 0, 0, 'userlist2', 1, 1, '', '', 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist3', '6Misc', 'User Defined List 3',11, 1, 0, 0, 0, 'userlist3', 1, 1, '', '' , 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist4', '6Misc', 'User Defined List 4',12, 1, 0, 0, 0, 'userlist4', 1, 1, '', '' , 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist5', '6Misc', 'User Defined List 5',13, 1, 0, 0, 0, 'userlist5', 1, 1, '', '' , 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist6', '6Misc', 'User Defined List 6',14, 1, 0, 0, 0, 'userlist6', 1, 1, '', '' , 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'userlist7', '6Misc', 'User Defined List 7',15, 1, 0, 0, 0, 'userlist7', 1, 1, '', '' , 'User Defined');
INSERT INTO `layout_options` VALUES ('DEM', 'regdate'  , '6Misc', 'Registration Date'  ,16, 4, 0,10,10, ''         , 1, 1, '', 'D', 'Start Date at This Clinic');
INSERT INTO `layout_options` VALUES ('DEM', 'hipaa_allowsms'  , '3Choices', 'Allow SMS'  , 5, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Allow SMS (text messages)?');
INSERT INTO `layout_options` VALUES ('DEM', 'hipaa_allowemail', '3Choices', 'Allow Email', 5, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Allow Email?');

INSERT INTO layout_options VALUES ('REF','refer_date'      ,'1Referral','Referral Date'                  , 1, 4,2, 0,  0,''         ,1,1,'C','D','Date of referral');
INSERT INTO layout_options VALUES ('REF','refer_from'      ,'1Referral','Refer By'                       , 2,10,2, 0,  0,''         ,1,1,'' ,'' ,'Referral By');
INSERT INTO layout_options VALUES ('REF','refer_to'        ,'1Referral','Refer To'                       , 3,14,2, 0,  0,''         ,1,1,'' ,'' ,'Referral To');
INSERT INTO layout_options VALUES ('REF','body'            ,'1Referral','Reason'                         , 4, 3,2,30,  3,''         ,1,1,'' ,'' ,'Reason for referral');
INSERT INTO layout_options VALUES ('REF','refer_external'  ,'1Referral','External Referral'              , 5, 1,1, 0,  0,'boolean'  ,1,1,'' ,'' ,'External referral?');
INSERT INTO layout_options VALUES ('REF','refer_diag'      ,'1Referral','Referrer Diagnosis'             , 6, 2,1,30,255,''         ,1,1,'' ,'X','Referrer diagnosis');
INSERT INTO layout_options VALUES ('REF','refer_risk_level','1Referral','Risk Level'                     , 7, 1,1, 0,  0,'risklevel',1,1,'' ,'' ,'Level of urgency');
INSERT INTO layout_options VALUES ('REF','refer_vitals'    ,'1Referral','Include Vitals'                 , 8, 1,1, 0,  0,'boolean'  ,1,1,'' ,'' ,'Include vitals data?');
INSERT INTO layout_options VALUES ('REF','refer_related_code','1Referral','Requested Service'            , 9,15,1,30,255,''         ,1,1,'' ,'' ,'Billing Code for Requested Service');
INSERT INTO layout_options VALUES ('REF','reply_date'      ,'2Counter-Referral','Reply Date'             ,10, 4,1, 0,  0,''         ,1,1,'' ,'D','Date of reply');
INSERT INTO layout_options VALUES ('REF','reply_from'      ,'2Counter-Referral','Reply From'             ,11, 2,1,30,255,''         ,1,1,'' ,'' ,'Who replied?');
INSERT INTO layout_options VALUES ('REF','reply_init_diag' ,'2Counter-Referral','Presumed Diagnosis'     ,12, 2,1,30,255,''         ,1,1,'' ,'' ,'Presumed diagnosis by specialist');
INSERT INTO layout_options VALUES ('REF','reply_final_diag','2Counter-Referral','Final Diagnosis'        ,13, 2,1,30,255,''         ,1,1,'' ,'' ,'Final diagnosis by specialist');
INSERT INTO layout_options VALUES ('REF','reply_documents' ,'2Counter-Referral','Documents'              ,14, 2,1,30,255,''         ,1,1,'' ,'' ,'Where may related scanned or paper documents be found?');
INSERT INTO layout_options VALUES ('REF','reply_findings'  ,'2Counter-Referral','Findings'               ,15, 3,1,30,  3,''         ,1,1,'' ,'' ,'Findings by specialist');
INSERT INTO layout_options VALUES ('REF','reply_services'  ,'2Counter-Referral','Services Provided'      ,16, 3,1,30,  3,''         ,1,1,'' ,'' ,'Service provided by specialist');
INSERT INTO layout_options VALUES ('REF','reply_recommend' ,'2Counter-Referral','Recommendations'        ,17, 3,1,30,  3,''         ,1,1,'' ,'' ,'Recommendations by specialist');
INSERT INTO layout_options VALUES ('REF','reply_rx_refer'  ,'2Counter-Referral','Prescriptions/Referrals',18, 3,1,30,  3,''         ,1,1,'' ,'' ,'Prescriptions and/or referrals by specialist');

INSERT INTO layout_options VALUES ('HIS','usertext11','1General','Risk Factors',1,21,1,0,0,'riskfactors',1,1,'','' ,'Risk Factors');
INSERT INTO layout_options VALUES ('HIS','exams'     ,'1General','Exams/Tests' ,2,23,1,0,0,'exams'      ,1,1,'','' ,'Exam and test results');
INSERT INTO layout_options VALUES ('HIS','history_father'   ,'2Family History','Father'   ,1, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','history_mother'   ,'2Family History','Mother'   ,2, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','history_siblings' ,'2Family History','Siblings' ,3, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','history_spouse'   ,'2Family History','Spouse'   ,4, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','history_offspring','2Family History','Offspring',5, 2,1,20,255,'',1,3,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_cancer'             ,'3Relatives','Cancer'             ,1, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_tuberculosis'       ,'3Relatives','Tuberculosis'       ,2, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_diabetes'           ,'3Relatives','Diabetes'           ,3, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_high_blood_pressure','3Relatives','High Blood Pressure',4, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_heart_problems'     ,'3Relatives','Heart Problems'     ,5, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_stroke'             ,'3Relatives','Stroke'             ,6, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_epilepsy'           ,'3Relatives','Epilepsy'           ,7, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_mental_illness'     ,'3Relatives','Mental Illness'     ,8, 2,1,20,255,'',1,1,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','relatives_suicide'            ,'3Relatives','Suicide'            ,9, 2,1,20,255,'',1,3,'','' ,'');
INSERT INTO layout_options VALUES ('HIS','coffee'              ,'4Lifestyle','Coffee'              ,1, 2,1,20,255,'',1,1,'','' ,'Caffeine consumption');
INSERT INTO layout_options VALUES ('HIS','tobacco'             ,'4Lifestyle','Tobacco'             ,2, 2,1,20,255,'',1,1,'','' ,'Tobacco use');
INSERT INTO layout_options VALUES ('HIS','alcohol'             ,'4Lifestyle','Alcohol'             ,3, 2,1,20,255,'',1,1,'','' ,'Alcohol consumption');
INSERT INTO layout_options VALUES ('HIS','sleep_patterns'      ,'4Lifestyle','Sleep Patterns'      ,4, 2,1,20,255,'',1,1,'','' ,'Sleep patterns');
INSERT INTO layout_options VALUES ('HIS','exercise_patterns'   ,'4Lifestyle','Exercise Patterns'   ,5, 2,1,20,255,'',1,1,'','' ,'Exercise patterns');
INSERT INTO layout_options VALUES ('HIS','seatbelt_use'        ,'4Lifestyle','Seatbelt Use'        ,6, 2,1,20,255,'',1,1,'','' ,'Seatbelt use');
INSERT INTO layout_options VALUES ('HIS','counseling'          ,'4Lifestyle','Counseling'          ,7, 2,1,20,255,'',1,1,'','' ,'Counseling activities');
INSERT INTO layout_options VALUES ('HIS','hazardous_activities','4Lifestyle','Hazardous Activities',8, 2,1,20,255,'',1,1,'','' ,'Hazardous activities');
INSERT INTO layout_options VALUES ('HIS','name_1'            ,'5Other','Name/Value'        ,1, 2,1,10,255,'',1,1,'','' ,'Name 1' );
INSERT INTO layout_options VALUES ('HIS','value_1'           ,'5Other',''                  ,2, 2,1,10,255,'',0,0,'','' ,'Value 1');
INSERT INTO layout_options VALUES ('HIS','name_2'            ,'5Other','Name/Value'        ,3, 2,1,10,255,'',1,1,'','' ,'Name 2' );
INSERT INTO layout_options VALUES ('HIS','value_2'           ,'5Other',''                  ,4, 2,1,10,255,'',0,0,'','' ,'Value 2');
INSERT INTO layout_options VALUES ('HIS','additional_history','5Other','Additional History',5, 3,1,30,  3,'',1,3,'' ,'' ,'Additional history notes');
INSERT INTO layout_options VALUES ('HIS','userarea11'        ,'5Other','User Defined Area 11',6,3,0,30,3,'',1,3,'','','User Defined');
INSERT INTO layout_options VALUES ('HIS','userarea12'        ,'5Other','User Defined Area 12',7,3,0,30,3,'',1,3,'','','User Defined');

-- --------------------------------------------------------

-- 
-- Table structure for table `list_options`
-- 

DROP TABLE IF EXISTS `list_options`;
CREATE TABLE `list_options` (
  `list_id` varchar(31) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `option_id` varchar(31) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `title` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `seq` int(11) NOT NULL default '0',
  `is_default` tinyint(1) NOT NULL default '0',
  `option_value` float NOT NULL default '0',
  PRIMARY KEY  (`list_id`,`option_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 
-- Dumping data for table `list_options`
-- 

INSERT INTO `list_options` VALUES ('yesno', 'NO', 'NO', 1, 0, 0);
INSERT INTO `list_options` VALUES ('yesno', 'YES', 'YES', 2, 0, 0);
INSERT INTO `list_options` VALUES ('titles', 'Mr.', 'Mr.', 1, 0, 0);
INSERT INTO `list_options` VALUES ('titles', 'Mrs.', 'Mrs.', 2, 0, 0);
INSERT INTO `list_options` VALUES ('titles', 'Ms.', 'Ms.', 3, 0, 0);
INSERT INTO `list_options` VALUES ('titles', 'Dr.', 'Dr.', 4, 0, 0);
INSERT INTO `list_options` VALUES ('sex', 'Female', 'Female', 1, 0, 0);
INSERT INTO `list_options` VALUES ('sex', 'Male', 'Male', 2, 0, 0);
INSERT INTO `list_options` VALUES ('marital', 'married', 'Married', 1, 0, 0);
INSERT INTO `list_options` VALUES ('marital', 'single', 'Single', 2, 0, 0);
INSERT INTO `list_options` VALUES ('marital', 'divorced', 'Divorced', 3, 0, 0);
INSERT INTO `list_options` VALUES ('marital', 'widowed', 'Widowed', 4, 0, 0);
INSERT INTO `list_options` VALUES ('marital', 'separated', 'Separated', 5, 0, 0);
INSERT INTO `list_options` VALUES ('marital', 'domestic partner', 'Domestic Partner', 6, 0, 0);
INSERT INTO `list_options` VALUES ('language', 'English', 'English', 1, 1, 0);
INSERT INTO `list_options` VALUES ('language', 'Spanish', 'Spanish', 2, 0, 0);
INSERT INTO `list_options` VALUES ('ethrace', 'Caucasian', 'Caucasian', 1, 0, 0);
INSERT INTO `list_options` VALUES ('ethrace', 'Asian', 'Asian', 2, 0, 0);
INSERT INTO `list_options` VALUES ('ethrace', 'Black', 'Black', 3, 0, 0);
INSERT INTO `list_options` VALUES ('ethrace', 'Hispanic', 'Hispanic', 4, 0, 0);
INSERT INTO `list_options` VALUES ('userlist1', 'sample', 'Sample', 1, 0, 0);
INSERT INTO `list_options` VALUES ('userlist2', 'sample', 'Sample', 1, 0, 0);
INSERT INTO `list_options` VALUES ('userlist3','sample','Sample',1,0,0);
INSERT INTO `list_options` VALUES ('userlist4','sample','Sample',1,0,0);
INSERT INTO `list_options` VALUES ('userlist5','sample','Sample',1,0,0);
INSERT INTO `list_options` VALUES ('userlist6','sample','Sample',1,0,0);
INSERT INTO `list_options` VALUES ('userlist7','sample','Sample',1,0,0);
INSERT INTO `list_options` VALUES ('pricelevel', 'standard', 'Standard', 1, 1, 0);
INSERT INTO `list_options` VALUES ('risklevel', 'low', 'Low', 1, 0, 0);
INSERT INTO `list_options` VALUES ('risklevel', 'medium', 'Medium', 2, 1, 0);
INSERT INTO `list_options` VALUES ('risklevel', 'high', 'High', 3, 0, 0);
INSERT INTO `list_options` VALUES ('boolean', '0', 'No', 1, 0, 0);
INSERT INTO `list_options` VALUES ('boolean', '1', 'Yes', 2, 0, 0);
INSERT INTO `list_options` VALUES ('country', 'USA', 'USA', 1, 0, 0);
INSERT INTO `list_options` VALUES ('state','CA','California',1,0,0);
INSERT INTO list_options VALUES ('refsource','Patient'      ,'Patient'      , 1,0,0);
INSERT INTO list_options VALUES ('refsource','Employee'     ,'Employee'     , 2,0,0);
INSERT INTO list_options VALUES ('refsource','Walk-In'      ,'Walk-In'      , 3,0,0);
INSERT INTO list_options VALUES ('refsource','Newspaper'    ,'Newspaper'    , 4,0,0);
INSERT INTO list_options VALUES ('refsource','Radio'        ,'Radio'        , 5,0,0);
INSERT INTO list_options VALUES ('refsource','T.V.'         ,'T.V.'         , 6,0,0);
INSERT INTO list_options VALUES ('refsource','Direct Mail'  ,'Direct Mail'  , 7,0,0);
INSERT INTO list_options VALUES ('refsource','Coupon'       ,'Coupon'       , 8,0,0);
INSERT INTO list_options VALUES ('refsource','Referral Card','Referral Card', 9,0,0);
INSERT INTO list_options VALUES ('refsource','Other'        ,'Other'        ,10,0,0);
INSERT INTO list_options VALUES ('riskfactors','vv' ,'Varicose Veins'                      , 1,0,0);
INSERT INTO list_options VALUES ('riskfactors','ht' ,'Hypertension'                        , 2,0,0);
INSERT INTO list_options VALUES ('riskfactors','db' ,'Diabetes'                            , 3,0,0);
INSERT INTO list_options VALUES ('riskfactors','sc' ,'Sickle Cell'                         , 4,0,0);
INSERT INTO list_options VALUES ('riskfactors','fib','Fibroids'                            , 5,0,0);
INSERT INTO list_options VALUES ('riskfactors','pid','PID (Pelvic Inflammatory Disease)'   , 6,0,0);
INSERT INTO list_options VALUES ('riskfactors','mig','Severe Migraine'                     , 7,0,0);
INSERT INTO list_options VALUES ('riskfactors','hd' ,'Heart Disease'                       , 8,0,0);
INSERT INTO list_options VALUES ('riskfactors','str','Thrombosis/Stroke'                   , 9,0,0);
INSERT INTO list_options VALUES ('riskfactors','hep','Hepatitis'                           ,10,0,0);
INSERT INTO list_options VALUES ('riskfactors','gb' ,'Gall Bladder Condition'              ,11,0,0);
INSERT INTO list_options VALUES ('riskfactors','br' ,'Breast Disease'                      ,12,0,0);
INSERT INTO list_options VALUES ('riskfactors','dpr','Depression'                          ,13,0,0);
INSERT INTO list_options VALUES ('riskfactors','all','Allergies'                           ,14,0,0);
INSERT INTO list_options VALUES ('riskfactors','inf','Infertility'                         ,15,0,0);
INSERT INTO list_options VALUES ('riskfactors','ast','Asthma'                              ,16,0,0);
INSERT INTO list_options VALUES ('riskfactors','ep' ,'Epilepsy'                            ,17,0,0);
INSERT INTO list_options VALUES ('riskfactors','cl' ,'Contact Lenses'                      ,18,0,0);
INSERT INTO list_options VALUES ('riskfactors','coc','Contraceptive Complication (specify)',19,0,0);
INSERT INTO list_options VALUES ('riskfactors','oth','Other (specify)'                     ,20,0,0);
INSERT INTO list_options VALUES ('exams' ,'brs','Breast Exam'          , 1,0,0);
INSERT INTO list_options VALUES ('exams' ,'cec','Cardiac Echo'         , 2,0,0);
INSERT INTO list_options VALUES ('exams' ,'ecg','ECG'                  , 3,0,0);
INSERT INTO list_options VALUES ('exams' ,'gyn','Gynecological Exam'   , 4,0,0);
INSERT INTO list_options VALUES ('exams' ,'mam','Mammogram'            , 5,0,0);
INSERT INTO list_options VALUES ('exams' ,'phy','Physical Exam'        , 6,0,0);
INSERT INTO list_options VALUES ('exams' ,'pro','Prostate Exam'        , 7,0,0);
INSERT INTO list_options VALUES ('exams' ,'rec','Rectal Exam'          , 8,0,0);
INSERT INTO list_options VALUES ('exams' ,'sic','Sigmoid/Colonoscopy'  , 9,0,0);
INSERT INTO list_options VALUES ('exams' ,'ret','Retinal Exam'         ,10,0,0);
INSERT INTO list_options VALUES ('exams' ,'flu','Flu Vaccination'      ,11,0,0);
INSERT INTO list_options VALUES ('exams' ,'pne','Pneumonia Vaccination',12,0,0);
INSERT INTO list_options VALUES ('exams' ,'ldl','LDL'                  ,13,0,0);
INSERT INTO list_options VALUES ('exams' ,'hem','Hemoglobin'           ,14,0,0);
INSERT INTO list_options VALUES ('exams' ,'psa','PSA'                  ,15,0,0);
INSERT INTO list_options VALUES ('drug_form','1','suspension' ,1,0,0);
INSERT INTO list_options VALUES ('drug_form','2','tablet'     ,2,0,0);
INSERT INTO list_options VALUES ('drug_form','3','capsule'    ,3,0,0);
INSERT INTO list_options VALUES ('drug_form','4','solution'   ,4,0,0);
INSERT INTO list_options VALUES ('drug_form','5','tsp'        ,5,0,0);
INSERT INTO list_options VALUES ('drug_form','6','ml'         ,6,0,0);
INSERT INTO list_options VALUES ('drug_form','7','units'      ,7,0,0);
INSERT INTO list_options VALUES ('drug_form','8','inhalations',8,0,0);
INSERT INTO list_options VALUES ('drug_form','9','gtts(drops)',9,0,0);
INSERT INTO list_options VALUES ('drug_units','1','mg'    ,1,0,0);
INSERT INTO list_options VALUES ('drug_units','2','mg/1cc',2,0,0);
INSERT INTO list_options VALUES ('drug_units','3','mg/2cc',3,0,0);
INSERT INTO list_options VALUES ('drug_units','4','mg/3cc',4,0,0);
INSERT INTO list_options VALUES ('drug_units','5','mg/4cc',5,0,0);
INSERT INTO list_options VALUES ('drug_units','6','mg/5cc',6,0,0);
INSERT INTO list_options VALUES ('drug_units','7','grams' ,7,0,0);
INSERT INTO list_options VALUES ('drug_units','8','mcg'   ,8,0,0);
INSERT INTO list_options VALUES ('drug_route', '1','Per Oris'         , 1,0,0);
INSERT INTO list_options VALUES ('drug_route', '2','Per Rectum'       , 2,0,0);
INSERT INTO list_options VALUES ('drug_route', '3','To Skin'          , 3,0,0);
INSERT INTO list_options VALUES ('drug_route', '4','To Affected Area' , 4,0,0);
INSERT INTO list_options VALUES ('drug_route', '5','Sublingual'       , 5,0,0);
INSERT INTO list_options VALUES ('drug_route',' 6','OS'               , 6,0,0);
INSERT INTO list_options VALUES ('drug_route', '7','OD'               , 7,0,0);
INSERT INTO list_options VALUES ('drug_route', '8','OU'               , 8,0,0);
INSERT INTO list_options VALUES ('drug_route', '9','SQ'               , 9,0,0);
INSERT INTO list_options VALUES ('drug_route','10','IM'               ,10,0,0);
INSERT INTO list_options VALUES ('drug_route','11','IV'               ,11,0,0);
INSERT INTO list_options VALUES ('drug_route','12','Per Nostril'      ,12,0,0);
INSERT INTO list_options VALUES ('drug_interval','1','b.i.d.',1,0,0);
INSERT INTO list_options VALUES ('drug_interval','2','t.i.d.',2,0,0);
INSERT INTO list_options VALUES ('drug_interval','3','q.i.d.',3,0,0);
INSERT INTO list_options VALUES ('drug_interval','4','q.3h'  ,4,0,0);
INSERT INTO list_options VALUES ('drug_interval','5','q.4h'  ,5,0,0);
INSERT INTO list_options VALUES ('drug_interval','6','q.5h'  ,6,0,0);
INSERT INTO list_options VALUES ('drug_interval','7','q.6h'  ,7,0,0);
INSERT INTO list_options VALUES ('drug_interval','8','q.8h'  ,8,0,0);
INSERT INTO list_options VALUES ('drug_interval','9','q.d.'  ,9,0,0);
INSERT INTO list_options VALUES ('chartloc','fileroom','File Room'              ,1,0,0);
INSERT INTO list_options VALUES ('lists' ,'boolean'      ,'Boolean'            , 1,0,0);
INSERT INTO list_options VALUES ('lists' ,'chartloc'     ,'Chart Storage Locations',1,0,0);
INSERT INTO list_options VALUES ('lists' ,'country'      ,'Country'            , 2,0,0);
INSERT INTO list_options VALUES ('lists' ,'drug_form'    ,'Drug Forms'         , 3,0,0);
INSERT INTO list_options VALUES ('lists' ,'drug_units'   ,'Drug Units'         , 4,0,0);
INSERT INTO list_options VALUES ('lists' ,'drug_route'   ,'Drug Routes'        , 5,0,0);
INSERT INTO list_options VALUES ('lists' ,'drug_interval','Drug Intervals'     , 6,0,0);
INSERT INTO list_options VALUES ('lists' ,'exams'        ,'Exams/Tests'        , 7,0,0);
INSERT INTO list_options VALUES ('lists' ,'feesheet'     ,'Fee Sheet'          , 8,0,0);
INSERT INTO list_options VALUES ('lists' ,'language'     ,'Language'           , 9,0,0);
INSERT INTO list_options VALUES ('lists' ,'marital'      ,'Marital Status'     ,10,0,0);
INSERT INTO list_options VALUES ('lists' ,'pricelevel'   ,'Price Level'        ,11,0,0);
INSERT INTO list_options VALUES ('lists' ,'ethrace'      ,'Race/Ethnicity'     ,12,0,0);
INSERT INTO list_options VALUES ('lists' ,'refsource'    ,'Referral Source'    ,13,0,0);
INSERT INTO list_options VALUES ('lists' ,'riskfactors'  ,'Risk Factors'       ,14,0,0);
INSERT INTO list_options VALUES ('lists' ,'risklevel'    ,'Risk Level'         ,15,0,0);
INSERT INTO list_options VALUES ('lists' ,'superbill'    ,'Service Category'   ,16,0,0);
INSERT INTO list_options VALUES ('lists' ,'sex'          ,'Sex'                ,17,0,0);
INSERT INTO list_options VALUES ('lists' ,'state'        ,'State'              ,18,0,0);
INSERT INTO list_options VALUES ('lists' ,'taxrate'      ,'Tax Rate'           ,19,0,0);
INSERT INTO list_options VALUES ('lists' ,'titles'       ,'Titles'             ,20,0,0);
INSERT INTO list_options VALUES ('lists' ,'yesno'        ,'Yes/No'             ,21,0,0);
INSERT INTO list_options VALUES ('lists' ,'userlist1'    ,'User Defined List 1',22,0,0);
INSERT INTO list_options VALUES ('lists' ,'userlist2'    ,'User Defined List 2',23,0,0);
INSERT INTO list_options VALUES ('lists' ,'userlist3'    ,'User Defined List 3',24,0,0);
INSERT INTO list_options VALUES ('lists' ,'userlist4'    ,'User Defined List 4',25,0,0);
INSERT INTO list_options VALUES ('lists' ,'userlist5'    ,'User Defined List 5',26,0,0);
INSERT INTO list_options VALUES ('lists' ,'userlist6'    ,'User Defined List 6',27,0,0);
INSERT INTO list_options VALUES ('lists' ,'userlist7'    ,'User Defined List 7',28,0,0);

-- --------------------------------------------------------

-- 
-- Table structure for table `lists`
-- 

DROP TABLE IF EXISTS `lists`;
CREATE TABLE `lists` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `type` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `title` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `begdate` date default NULL,
  `enddate` date default NULL,
  `returndate` date default NULL,
  `occurrence` int(11) default '0',
  `classification` int(11) default '0',
  `referredby` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `extrainfo` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `diagnosis` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `activity` tinyint(4) default NULL,
  `comments` longtext character set utf8 collate utf8_unicode_ci,
  `pid` bigint(20) default NULL,
  `user` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `groupname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `outcome` int(11) NOT NULL default '0',
  `destination` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `log`
-- 

DROP TABLE IF EXISTS `log`;
CREATE TABLE `log` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `event` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `user` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `groupname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `comments` longtext character set utf8 collate utf8_unicode_ci,
  `user_notes` longtext character set utf8 collate utf8_unicode_ci,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `notes`
-- 

DROP TABLE IF EXISTS `notes`;
CREATE TABLE `notes` (
  `id` int(11) NOT NULL default '0',
  `foreign_id` int(11) NOT NULL default '0',
  `note` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `owner` int(11) default NULL,
  `date` datetime default NULL,
  `revision` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  KEY `foreign_id` (`owner`),
  KEY `foreign_id_2` (`foreign_id`),
  KEY `date` (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `onotes`
-- 

DROP TABLE IF EXISTS `onotes`;
CREATE TABLE `onotes` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `body` longtext character set utf8 collate utf8_unicode_ci,
  `user` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `groupname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `activity` tinyint(4) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_module_vars`
-- 

DROP TABLE IF EXISTS `openemr_module_vars`;
CREATE TABLE `openemr_module_vars` (
  `pn_id` int(11) unsigned NOT NULL auto_increment,
  `pn_modname` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `pn_name` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `pn_value` longtext character set utf8 collate utf8_unicode_ci,
  PRIMARY KEY  (`pn_id`),
  KEY `pn_modname` (`pn_modname`),
  KEY `pn_name` (`pn_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=235 ;

-- 
-- Dumping data for table `openemr_module_vars`
-- 

INSERT INTO `openemr_module_vars` VALUES (234, 'PostCalendar', 'pcNotifyEmail', '');
INSERT INTO `openemr_module_vars` VALUES (233, 'PostCalendar', 'pcNotifyAdmin', '0');
INSERT INTO `openemr_module_vars` VALUES (232, 'PostCalendar', 'pcCacheLifetime', '3600');
INSERT INTO `openemr_module_vars` VALUES (231, 'PostCalendar', 'pcUseCache', '0');
INSERT INTO `openemr_module_vars` VALUES (230, 'PostCalendar', 'pcDefaultView', 'day');
INSERT INTO `openemr_module_vars` VALUES (229, 'PostCalendar', 'pcTimeIncrement', '5');
INSERT INTO `openemr_module_vars` VALUES (228, 'PostCalendar', 'pcAllowUserCalendar', '1');
INSERT INTO `openemr_module_vars` VALUES (227, 'PostCalendar', 'pcAllowSiteWide', '1');
INSERT INTO `openemr_module_vars` VALUES (226, 'PostCalendar', 'pcTemplate', 'default');
INSERT INTO `openemr_module_vars` VALUES (225, 'PostCalendar', 'pcEventDateFormat', '%Y-%m-%d');
INSERT INTO `openemr_module_vars` VALUES (224, 'PostCalendar', 'pcDisplayTopics', '0');
INSERT INTO `openemr_module_vars` VALUES (223, 'PostCalendar', 'pcListHowManyEvents', '15');
INSERT INTO `openemr_module_vars` VALUES (222, 'PostCalendar', 'pcAllowDirectSubmit', '1');
INSERT INTO `openemr_module_vars` VALUES (221, 'PostCalendar', 'pcUsePopups', '0');
INSERT INTO `openemr_module_vars` VALUES (220, 'PostCalendar', 'pcDayHighlightColor', '#EEEEEE');
INSERT INTO `openemr_module_vars` VALUES (219, 'PostCalendar', 'pcFirstDayOfWeek', '1');
INSERT INTO `openemr_module_vars` VALUES (218, 'PostCalendar', 'pcUseInternationalDates', '0');
INSERT INTO `openemr_module_vars` VALUES (217, 'PostCalendar', 'pcEventsOpenInNewWindow', '0');
INSERT INTO `openemr_module_vars` VALUES (216, 'PostCalendar', 'pcTime24Hours', '0');

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_modules`
-- 

DROP TABLE IF EXISTS `openemr_modules`;
CREATE TABLE `openemr_modules` (
  `pn_id` int(11) unsigned NOT NULL auto_increment,
  `pn_name` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `pn_type` int(6) NOT NULL default '0',
  `pn_displayname` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `pn_description` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `pn_regid` int(11) unsigned NOT NULL default '0',
  `pn_directory` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `pn_version` varchar(10) character set utf8 collate utf8_unicode_ci default NULL,
  `pn_admin_capable` tinyint(1) NOT NULL default '0',
  `pn_user_capable` tinyint(1) NOT NULL default '0',
  `pn_state` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`pn_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=47 ;

-- 
-- Dumping data for table `openemr_modules`
-- 

INSERT INTO `openemr_modules` VALUES (46, 'PostCalendar', 2, 'PostCalendar', 'PostNuke Calendar Module', 0, 'PostCalendar', '4.0.0', 1, 1, 3);

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_postcalendar_categories`
-- 

DROP TABLE IF EXISTS `openemr_postcalendar_categories`;
CREATE TABLE `openemr_postcalendar_categories` (
  `pc_catid` int(11) unsigned NOT NULL auto_increment,
  `pc_catname` varchar(100) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_catcolor` varchar(50) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_catdesc` text character set utf8 collate utf8_unicode_ci,
  `pc_recurrtype` int(1) NOT NULL default '0',
  `pc_enddate` date default NULL,
  `pc_recurrspec` text character set utf8 collate utf8_unicode_ci,
  `pc_recurrfreq` int(3) NOT NULL default '0',
  `pc_duration` bigint(20) NOT NULL default '0',
  `pc_end_date_flag` tinyint(1) NOT NULL default '0',
  `pc_end_date_type` int(2) default NULL,
  `pc_end_date_freq` int(11) NOT NULL default '0',
  `pc_end_all_day` tinyint(1) NOT NULL default '0',
  `pc_dailylimit` int(2) NOT NULL default '0',
  PRIMARY KEY  (`pc_catid`),
  KEY `basic_cat` (`pc_catname`,`pc_catcolor`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=11 ;

-- 
-- Dumping data for table `openemr_postcalendar_categories`
-- 

INSERT INTO `openemr_postcalendar_categories` VALUES (5, 'Office Visit', '#FFFFCC', 'Normal Office Visit', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 900, 0, 0, 0, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (4, 'Vacation', '#EFEFEF', 'Reserved for use to define Scheduled Vacation Time', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 0, 0, 0, 0, 1, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (1, 'No Show', '#DDDDDD', 'Reserved to define when an event did not occur as specified.', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (2, 'In Office', '#99CCFF', 'Reserved todefine when a provider may haveavailable appointments after.', 1, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 0, 1, 3, 2, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (3, 'Out Of Office', '#99FFFF', 'Reserved to define when a provider may not have available appointments after.', 1, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 0, 1, 3, 2, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (8, 'Lunch', '#FFFF33', 'Lunch', 1, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 3600, 0, 3, 2, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (9, 'Established Patient', '#CCFF33', '', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 900, 0, 0, 0, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (10,'New Patient', '#CCFFFF', '', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 1800, 0, 0, 0, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (11,'Reserved','#FF7777','Reserved',1,NULL,'a:5:{s:17:\"event_repeat_freq\";s:1:\"1\";s:22:\"event_repeat_freq_type\";s:1:\"4\";s:19:\"event_repeat_on_num\";s:1:\"1\";s:19:\"event_repeat_on_day\";s:1:\"0\";s:20:\"event_repeat_on_freq\";s:1:\"0\";}',0,900,0,3,2,0,0);

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_postcalendar_events`
-- 

DROP TABLE IF EXISTS `openemr_postcalendar_events`;
CREATE TABLE `openemr_postcalendar_events` (
  `pc_eid` int(11) unsigned NOT NULL auto_increment,
  `pc_catid` int(11) NOT NULL default '0',
  `pc_multiple` int(10) unsigned NOT NULL,
  `pc_aid` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_pid` varchar(11) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_title` varchar(150) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_time` datetime default NULL,
  `pc_hometext` text character set utf8 collate utf8_unicode_ci,
  `pc_comments` int(11) default '0',
  `pc_counter` mediumint(8) unsigned default '0',
  `pc_topic` int(3) NOT NULL default '1',
  `pc_informant` varchar(20) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_eventDate` date NOT NULL default '0000-00-00',
  `pc_endDate` date NOT NULL default '0000-00-00',
  `pc_duration` bigint(20) NOT NULL default '0',
  `pc_recurrtype` int(1) NOT NULL default '0',
  `pc_recurrspec` text character set utf8 collate utf8_unicode_ci,
  `pc_recurrfreq` int(3) NOT NULL default '0',
  `pc_startTime` time default NULL,
  `pc_endTime` time default NULL,
  `pc_alldayevent` int(1) NOT NULL default '0',
  `pc_location` text character set utf8 collate utf8_unicode_ci,
  `pc_conttel` varchar(50) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_contname` varchar(50) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_contemail` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_website` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_fee` varchar(50) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_eventstatus` int(11) NOT NULL default '0',
  `pc_sharing` int(11) NOT NULL default '0',
  `pc_language` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_apptstatus` char(1) character set latin1 NOT NULL default '-',
  `pc_prefcatid` int(11) NOT NULL default '0',
  `pc_facility` smallint(6) NOT NULL default '0' COMMENT 'facility id for this event',
  `pc_sendalertsms` VARCHAR(3) NOT NULL DEFAULT 'NO',
  `pc_sendalertemail` VARCHAR( 3 ) NOT NULL DEFAULT 'NO',
  PRIMARY KEY  (`pc_eid`),
  KEY `basic_event` (`pc_catid`,`pc_aid`,`pc_eventDate`,`pc_endDate`,`pc_eventstatus`,`pc_sharing`,`pc_topic`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=7 ;

-- 
-- Dumping data for table `openemr_postcalendar_events`
-- 

INSERT INTO `openemr_postcalendar_events` VALUES (3, 2, 0, '1', '', 'In Office', '2005-03-03 12:22:31', ':text:', 0, 0, 0, '1', '2005-03-03', '2007-03-03', 0, 1, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, '09:00:00', '09:00:00', 0, 'a:6:{s:14:"event_location";N;s:13:"event_street1";N;s:13:"event_street2";N;s:10:"event_city";N;s:11:"event_state";N;s:12:"event_postal";N;}', '', '', '', '', '', 1, 1, '', '-', 0, 0, 'NO', 'NO');
INSERT INTO `openemr_postcalendar_events` VALUES (5, 3, 0, '1', '', 'Out Of Office', '2005-03-03 12:22:52', ':text:', 0, 0, 0, '1', '2005-03-03', '2007-03-03', 0, 1, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, '17:00:00', '17:00:00', 0, 'a:6:{s:14:"event_location";N;s:13:"event_street1";N;s:13:"event_street2";N;s:10:"event_city";N;s:11:"event_state";N;s:12:"event_postal";N;}', '', '', '', '', '', 1, 1, '', '-', 0, 0, 'NO', 'NO');
INSERT INTO `openemr_postcalendar_events` VALUES (6, 8, 0, '1', '', 'Lunch', '2005-03-03 12:23:31', ':text:', 0, 0, 0, '1', '2005-03-03', '2007-03-03', 3600, 1, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, '12:00:00', '13:00:00', 0, 'a:6:{s:14:"event_location";N;s:13:"event_street1";N;s:13:"event_street2";N;s:10:"event_city";N;s:11:"event_state";N;s:12:"event_postal";N;}', '', '', '', '', '', 1, 1, '', '-', 0, 0, 'NO', 'NO');

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_postcalendar_limits`
-- 

DROP TABLE IF EXISTS `openemr_postcalendar_limits`;
CREATE TABLE `openemr_postcalendar_limits` (
  `pc_limitid` int(11) NOT NULL auto_increment,
  `pc_catid` int(11) NOT NULL default '0',
  `pc_starttime` time NOT NULL default '00:00:00',
  `pc_endtime` time NOT NULL default '00:00:00',
  `pc_limit` int(11) NOT NULL default '1',
  PRIMARY KEY  (`pc_limitid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_postcalendar_topics`
-- 

DROP TABLE IF EXISTS `openemr_postcalendar_topics`;
CREATE TABLE `openemr_postcalendar_topics` (
  `pc_catid` int(11) unsigned NOT NULL auto_increment,
  `pc_catname` varchar(100) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_catcolor` varchar(50) character set utf8 collate utf8_unicode_ci default NULL,
  `pc_catdesc` text character set utf8 collate utf8_unicode_ci,
  PRIMARY KEY  (`pc_catid`),
  KEY `basic_cat` (`pc_catname`,`pc_catcolor`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_session_info`
-- 

DROP TABLE IF EXISTS `openemr_session_info`;
CREATE TABLE `openemr_session_info` (
  `pn_sessid` varchar(32) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `pn_ipaddr` varchar(20) character set utf8 collate utf8_unicode_ci default NULL,
  `pn_firstused` int(11) NOT NULL default '0',
  `pn_lastused` int(11) NOT NULL default '0',
  `pn_uid` int(11) NOT NULL default '0',
  `pn_vars` blob,
  PRIMARY KEY  (`pn_sessid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 
-- Dumping data for table `openemr_session_info`
-- 

INSERT INTO `openemr_session_info` VALUES ('978d31441dccd350d406bfab98978f20', '127.0.0.1', 1109233952, 1109234177, 0, NULL);

-- --------------------------------------------------------

-- 
-- Table structure for table `patient_data`
-- 

DROP TABLE IF EXISTS `patient_data`;
CREATE TABLE `patient_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `title` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `language` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `financial` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `fname` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `lname` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `mname` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `DOB` date default NULL,
  `street` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `postal_code` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `city` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `state` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `country_code` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `drivers_license` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `ss` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `occupation` longtext character set utf8 collate utf8_unicode_ci,
  `phone_home` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `phone_biz` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `phone_contact` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `phone_cell` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `pharmacy_id` int(11) NOT NULL default '0',
  `status` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `contact_relationship` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `date` datetime default NULL,
  `sex` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `referrer` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `referrerID` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `providerID` int(11) default NULL,
  `email` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `ethnoracial` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `interpretter` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `migrantseasonal` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `family_size` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `monthly_income` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `homeless` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `financial_review` datetime default NULL,
  `pubpid` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `pid` bigint(20) NOT NULL default '0',
  `genericname1` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `genericval1` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `genericname2` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `genericval2` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `hipaa_mail` varchar(3) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `hipaa_voice` varchar(3) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `hipaa_notice` varchar(3) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `hipaa_message` varchar(20) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `hipaa_allowsms` VARCHAR( 3 ) NOT NULL DEFAULT 'NO',
  `hipaa_allowemail` VARCHAR( 3 ) NOT NULL DEFAULT 'NO',
  `squad` varchar(32) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `fitness` int(11) NOT NULL default '0',
  `referral_source` varchar(30) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `usertext1` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext2` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext3` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext4` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext5` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext6` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext7` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `usertext8` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `userlist1` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `userlist2` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `userlist3` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `userlist4` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `userlist5` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `userlist6` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `userlist7` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `pricelevel` varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL default 'standard',
  `regdate`     date DEFAULT NULL COMMENT 'Registration Date',
  `contrastart` date DEFAULT NULL COMMENT 'Date contraceptives initially used',
  UNIQUE KEY `pid` (`pid`),
  KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `payments`
-- 

DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
  `id` bigint(20) NOT NULL auto_increment,
  `pid` bigint(20) NOT NULL default '0',
  `dtime` datetime NOT NULL,
  `encounter` bigint(20) NOT NULL default '0',
  `user` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `method` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `source` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `amount1` decimal(12,2) NOT NULL default '0.00',
  `amount2` decimal(12,2) NOT NULL default '0.00',
  `posted1` decimal(12,2) NOT NULL default '0.00',
  `posted2` decimal(12,2) NOT NULL default '0.00',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `pharmacies`
-- 

DROP TABLE IF EXISTS `pharmacies`;
CREATE TABLE `pharmacies` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `transmit_method` int(11) NOT NULL default '1',
  `email` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `phone_numbers`
-- 

DROP TABLE IF EXISTS `phone_numbers`;
CREATE TABLE `phone_numbers` (
  `id` int(11) NOT NULL default '0',
  `country_code` varchar(5) character set utf8 collate utf8_unicode_ci default NULL,
  `area_code` char(3) character set latin1 default NULL,
  `prefix` char(3) character set latin1 default NULL,
  `number` varchar(4) character set utf8 collate utf8_unicode_ci default NULL,
  `type` int(11) default NULL,
  `foreign_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `foreign_id` (`foreign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_bookmark`
-- 

DROP TABLE IF EXISTS `pma_bookmark`;
CREATE TABLE `pma_bookmark` (
  `id` int(11) NOT NULL auto_increment,
  `dbase` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `user` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `label` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `query` text character set utf8 collate utf8_unicode_ci,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Bookmarks' AUTO_INCREMENT=10 ;

-- 
-- Dumping data for table `pma_bookmark`
-- 

INSERT INTO `pma_bookmark` VALUES (2, 'openemr', 'openemr', 'Aggregate Race Statistics', 'SELECT ethnoracial as "Race/Ethnicity", count(*) as Count FROM  `patient_data` WHERE 1 group by ethnoracial');
INSERT INTO `pma_bookmark` VALUES (9, 'openemr', 'openemr', 'Search by Code', 'SELECT  b.code, concat(pd.fname," ", pd.lname) as "Patient Name", concat(u.fname," ", u.lname) as "Provider Name", en.reason as "Encounter Desc.", en.date\r\nFROM billing as b\r\nLEFT JOIN users AS u ON b.user = u.id\r\nLEFT JOIN patient_data as pd on b.pid = pd.pid\r\nLEFT JOIN form_encounter as en on b.encounter = en.encounter and b.pid = en.pid\r\nWHERE 1 /* and b.code like ''%[VARIABLE]%'' */ ORDER BY b.code');
INSERT INTO `pma_bookmark` VALUES (8, 'openemr', 'openemr', 'Count No Shows By Provider since Interval ago', 'SELECT concat( u.fname,  " ", u.lname )  AS  "Provider Name", u.id AS  "Provider ID", count(  DISTINCT ev.pc_eid )  AS  "Number of No Shows"/* , concat(DATE_FORMAT(NOW(),''%Y-%m-%d''), '' and '',DATE_FORMAT(DATE_ADD(now(), INTERVAL [VARIABLE]),''%Y-%m-%d'') ) as "Between Dates" */ FROM  `openemr_postcalendar_events`  AS ev LEFT  JOIN users AS u ON ev.pc_aid = u.id WHERE ev.pc_catid =1/* and ( ev.pc_eventDate >= DATE_SUB(now(), INTERVAL [VARIABLE]) )  */\r\nGROUP  BY u.id;');
INSERT INTO `pma_bookmark` VALUES (6, 'openemr', 'openemr', 'Appointments By Race/Ethnicity from today plus interval', 'SELECT  count(pd.ethnoracial) as "Number of Appointments", pd.ethnoracial AS  "Race/Ethnicity" /* , concat(DATE_FORMAT(NOW(),''%Y-%m-%d''), '' and '',DATE_FORMAT(DATE_ADD(now(), INTERVAL [VARIABLE]),''%Y-%m-%d'') ) as "Between Dates" */ FROM openemr_postcalendar_events AS ev LEFT  JOIN   `patient_data`  AS pd ON  pd.pid = ev.pc_pid where ev.pc_eventstatus=1 and ev.pc_catid = 5 and ev.pc_eventDate >= now()  /* and ( ev.pc_eventDate <= DATE_ADD(now(), INTERVAL [VARIABLE]) )  */ group by pd.ethnoracial');

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_column_info`
-- 

DROP TABLE IF EXISTS `pma_column_info`;
CREATE TABLE `pma_column_info` (
  `id` int(5) unsigned NOT NULL auto_increment,
  `db_name` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `table_name` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `column_name` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `comment` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `mimetype` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `transformation` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `transformation_options` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column Information for phpMyAdmin' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_history`
-- 

DROP TABLE IF EXISTS `pma_history`;
CREATE TABLE `pma_history` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `username` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `db` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `table` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `timevalue` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `sqlquery` text character set utf8 collate utf8_unicode_ci,
  PRIMARY KEY  (`id`),
  KEY `username` (`username`,`db`,`table`,`timevalue`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_pdf_pages`
-- 

DROP TABLE IF EXISTS `pma_pdf_pages`;
CREATE TABLE `pma_pdf_pages` (
  `db_name` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `page_nr` int(10) unsigned NOT NULL auto_increment,
  `page_descr` varchar(50) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`page_nr`),
  KEY `db_name` (`db_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF Relationpages for PMA' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_relation`
-- 

DROP TABLE IF EXISTS `pma_relation`;
CREATE TABLE `pma_relation` (
  `master_db` varchar(64) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `master_table` varchar(64) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `master_field` varchar(64) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `foreign_db` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `foreign_table` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  `foreign_field` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`master_db`,`master_table`,`master_field`),
  KEY `foreign_field` (`foreign_db`,`foreign_table`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_table_coords`
-- 

DROP TABLE IF EXISTS `pma_table_coords`;
CREATE TABLE `pma_table_coords` (
  `db_name` varchar(64) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `table_name` varchar(64) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `pdf_page_number` int(11) NOT NULL default '0',
  `x` float unsigned NOT NULL default '0',
  `y` float unsigned NOT NULL default '0',
  PRIMARY KEY  (`db_name`,`table_name`,`pdf_page_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_table_info`
-- 

DROP TABLE IF EXISTS `pma_table_info`;
CREATE TABLE `pma_table_info` (
  `db_name` varchar(64) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `table_name` varchar(64) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `display_field` varchar(64) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`db_name`,`table_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

-- 
-- Table structure for table `pnotes`
-- 

DROP TABLE IF EXISTS `pnotes`;
CREATE TABLE `pnotes` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `body` longtext character set utf8 collate utf8_unicode_ci,
  `pid` bigint(20) default NULL,
  `user` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `groupname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `activity` tinyint(4) default NULL,
  `authorized` tinyint(4) default NULL,
  `title` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `assigned_to` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `prescriptions`
-- 

DROP TABLE IF EXISTS `prescriptions`;
CREATE TABLE `prescriptions` (
  `id` int(11) NOT NULL auto_increment,
  `patient_id` int(11) default NULL,
  `filled_by_id` int(11) default NULL,
  `pharmacy_id` int(11) default NULL,
  `date_added` date default NULL,
  `date_modified` date default NULL,
  `provider_id` int(11) default NULL,
  `start_date` date default NULL,
  `drug` varchar(150) character set utf8 collate utf8_unicode_ci default NULL,
  `drug_id` int(11) NOT NULL default '0',
  `form` int(3) default NULL,
  `dosage` varchar(100) character set utf8 collate utf8_unicode_ci default NULL,
  `quantity` varchar(31) character set utf8 collate utf8_unicode_ci default NULL,
  `size` float unsigned default NULL,
  `unit` int(11) default NULL,
  `route` int(11) default NULL,
  `interval` int(11) default NULL,
  `substitute` int(11) default NULL,
  `refills` int(11) default NULL,
  `per_refill` int(11) default NULL,
  `filled_date` date default NULL,
  `medication` int(11) default NULL,
  `note` text character set utf8 collate utf8_unicode_ci,
  `active` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `prices`
-- 

DROP TABLE IF EXISTS `prices`;
CREATE TABLE `prices` (
  `pr_id` varchar(11) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `pr_selector` varchar(15) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `pr_level` varchar(31) character set utf8 collate utf8_unicode_ci NOT NULL default '',
  `pr_price` decimal(12,2) NOT NULL default '0.00' COMMENT 'price in local currency',
  PRIMARY KEY  (`pr_id`,`pr_selector`,`pr_level`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

-- 
-- Table structure for table `registry`
-- 

DROP TABLE IF EXISTS `registry`;
CREATE TABLE `registry` (
  `name` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `state` tinyint(4) default NULL,
  `directory` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `id` bigint(20) NOT NULL auto_increment,
  `sql_run` tinyint(4) default NULL,
  `unpackaged` tinyint(4) default NULL,
  `date` datetime default NULL,
  `priority` int(11) default '0',
  `category` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `nickname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=16 ;

-- 
-- Dumping data for table `registry`
-- 

INSERT INTO `registry` VALUES ('New Encounter Form', 1, 'newpatient', 1, 1, 1, '2003-09-14 15:16:45', 0, 'category', '');
INSERT INTO `registry` VALUES ('Review of Systems Checks', 1, 'reviewofs', 9, 1, 1, '2003-09-14 15:16:45', 0, 'category', '');
INSERT INTO `registry` VALUES ('Speech Dictation', 1, 'dictation', 10, 1, 1, '2003-09-14 15:16:45', 0, 'category', '');
INSERT INTO `registry` VALUES ('SOAP', 1, 'soap', 11, 1, 1, '2005-03-03 00:16:35', 0, 'category', '');
INSERT INTO `registry` VALUES ('Vitals', 1, 'vitals', 12, 1, 1, '2005-03-03 00:16:34', 0, 'category', '');
INSERT INTO `registry` VALUES ('Review Of Systems', 1, 'ros', 13, 1, 1, '2005-03-03 00:16:30', 0, 'category', '');
INSERT INTO `registry` VALUES ('Fee Sheet', 1, 'fee_sheet', 14, 1, 1, '2007-07-28 00:00:00', 0, 'category', '');
INSERT INTO `registry` VALUES ('Misc Billing Options HCFA', 1, 'misc_billing_options', 15, 1, 1, '2007-07-28 00:00:00', 0, 'category', '');

-- --------------------------------------------------------

-- 
-- Table structure for table `sequences`
-- 

DROP TABLE IF EXISTS `sequences`;
CREATE TABLE `sequences` (
  `id` int(11) unsigned NOT NULL default '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 
-- Dumping data for table `sequences`
-- 

INSERT INTO `sequences` VALUES (1);

-- --------------------------------------------------------

-- 
-- Table structure for table `transactions`
-- 

DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `id`                      bigint(20)   NOT NULL auto_increment,
  `date`                    datetime     default NULL,
  `title`                   varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `body`                    longtext     character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `pid`                     bigint(20)   default NULL,
  `user`                    varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `groupname`               varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `authorized`              tinyint(4)   default NULL,
  `refer_date`              date         DEFAULT NULL,
  `refer_from`              int(11)      NOT NULL DEFAULT 0,
  `refer_to`                int(11)      NOT NULL DEFAULT 0,
  `refer_diag`              varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `refer_risk_level`        varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `refer_vitals`            tinyint(1)   NOT NULL DEFAULT 0,
  `refer_external`          tinyint(1)   NOT NULL DEFAULT 0,
  `refer_related_code`      varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `reply_date`              date         DEFAULT NULL,
  `reply_from`              varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `reply_init_diag`         varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `reply_final_diag`        varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `reply_documents`         varchar(255) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `reply_findings`          text         character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `reply_services`          text         character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `reply_recommend`         text         character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  `reply_rx_refer`          text         character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `users`
-- 

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL auto_increment,
  `username` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `password` longtext character set utf8 collate utf8_unicode_ci,
  `authorized` tinyint(4) default NULL,
  `info` longtext character set utf8 collate utf8_unicode_ci,
  `source` tinyint(4) default NULL,
  `fname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `mname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `lname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `federaltaxid` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `federaldrugid` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `upin` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `facility` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `facility_id` int(11) NOT NULL default '0',
  `see_auth` int(11) NOT NULL default '1',
  `active` tinyint(1) NOT NULL default '1',
  `npi` varchar(15) character set utf8 collate utf8_unicode_ci default NULL,
  `title` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `specialty` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `billname` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `email` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `url` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `assistant` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `organization` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `valedictory` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `street` varchar(60) character set utf8 collate utf8_unicode_ci default NULL,
  `streetb` varchar(60) character set utf8 collate utf8_unicode_ci default NULL,
  `city` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `state` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `zip` varchar(20) character set utf8 collate utf8_unicode_ci default NULL,
  `street2` varchar(60) character set utf8 collate utf8_unicode_ci default NULL,
  `streetb2` varchar(60) character set utf8 collate utf8_unicode_ci default NULL,
  `city2` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `state2` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `zip2` varchar(20) character set utf8 collate utf8_unicode_ci default NULL,
  `phone` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `fax` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `phonew1` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `phonew2` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `phonecell` varchar(30) character set utf8 collate utf8_unicode_ci default NULL,
  `notes` text character set utf8 collate utf8_unicode_ci,
  `cal_ui` tinyint(4) NOT NULL default '1',
  `taxonomy` varchar(30) character set utf8 collate utf8_unicode_ci NOT NULL DEFAULT '207Q00000X',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `x12_partners`
-- 

DROP TABLE IF EXISTS `x12_partners`;
CREATE TABLE `x12_partners` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `id_number` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `x12_sender_id` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `x12_receiver_id` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `x12_version` varchar(255) character set utf8 collate utf8_unicode_ci default NULL,
  `processing_format` enum('standard','medi-cal','cms','proxymed') character set latin1 default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

------------------------------------------------------------------------------------- 
-- Table structure for table `automatic_notification`
-- 

DROP TABLE IF EXISTS `automatic_notification`;
CREATE TABLE `automatic_notification` (
  `notification_id` int(5) NOT NULL auto_increment,
  `sms_gateway_type` varchar(255) NOT NULL,
  `next_app_date` date NOT NULL,
  `next_app_time` varchar(10) NOT NULL,
  `provider_name` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `email_sender` varchar(100) NOT NULL,
  `email_subject` varchar(100) NOT NULL,
  `type` enum('SMS','Email') NOT NULL default 'SMS',
  `notification_sent_date` datetime NOT NULL,
  PRIMARY KEY  (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- 
-- Dumping data for table `automatic_notification`
-- 

INSERT INTO `automatic_notification` (`notification_id`, `sms_gateway_type`, `next_app_date`, `next_app_time`, `provider_name`, `message`, `email_sender`, `email_subject`, `type`, `notification_sent_date`) VALUES (1, 'CLICKATELL', '0000-00-00', ':', 'EMR GROUP 1 .. SMS', 'Welcome to EMR GROUP 1.. SMS', '', '', 'SMS', '0000-00-00 00:00:00'),
(2, '', '2007-10-02', '05:50', 'EMR GROUP', 'Welcome to EMR GROUP . Email', 'EMR Group', 'Welcome to EMR GROUP', 'Email', '2007-09-30 00:00:00');

-- --------------------------------------------------------

-- 
-- Table structure for table `notification_log`
-- 

DROP TABLE IF EXISTS `notification_log`;
CREATE TABLE `notification_log` (
  `iLogId` int(11) NOT NULL auto_increment,
  `pid` int(7) NOT NULL,
  `pc_eid` int(11) unsigned NULL,
  `sms_gateway_type` varchar(50) NOT NULL,
  `smsgateway_info` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `email_sender` varchar(255) NOT NULL,
  `email_subject` varchar(255) NOT NULL,
  `type` enum('SMS','Email') NOT NULL,
  `patient_info` text NOT NULL,
  `pc_eventDate` date NOT NULL,
  `pc_endDate` date NOT NULL,
  `pc_startTime` time NOT NULL,
  `pc_endTime` time NOT NULL,
  `dSentDateTime` datetime NOT NULL,
  PRIMARY KEY  (`iLogId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `notification_settings`
-- 

DROP TABLE IF EXISTS `notification_settings`;
CREATE TABLE `notification_settings` (
  `SettingsId` int(3) NOT NULL auto_increment,
  `Send_SMS_Before_Hours` int(3) NOT NULL,
  `Send_Email_Before_Hours` int(3) NOT NULL,
  `SMS_gateway_username` varchar(100) NOT NULL,
  `SMS_gateway_password` varchar(100) NOT NULL,
  `SMS_gateway_apikey` varchar(100) NOT NULL,
  `type` varchar(50) NOT NULL,
  PRIMARY KEY  (`SettingsId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- 
-- Dumping data for table `notification_settings`
-- 

INSERT INTO `notification_settings` (`SettingsId`, `Send_SMS_Before_Hours`, `Send_Email_Before_Hours`, `SMS_gateway_username`, `SMS_gateway_password`, `SMS_gateway_apikey`, `type`) VALUES (1, 150, 150, 'sms username', 'sms password', 'sms api key', 'SMS/Email Settings');

-- -------------------------------------------------------------------

CREATE TABLE chart_tracker (
  ct_pid            int(11)       NOT NULL,
  ct_when           datetime      NOT NULL,
  ct_userid         bigint(20)    NOT NULL DEFAULT 0,
  ct_location       varchar(31)   NOT NULL DEFAULT '',
  PRIMARY KEY (ct_pid, ct_when)
) ENGINE=MyISAM;

CREATE TABLE ar_session (
  session_id     int unsigned  NOT NULL AUTO_INCREMENT,
  payer_id       int(11)       NOT NULL            COMMENT '0=pt else references insurance_companies.id',
  user_id        int(11)       NOT NULL            COMMENT 'references users.id for session owner',
  closed         tinyint(1)    NOT NULL DEFAULT 0  COMMENT '0=no, 1=yes',
  reference      varchar(255)  NOT NULL DEFAULT '' COMMENT 'check or EOB number',
  check_date     date          DEFAULT NULL,
  deposit_date   date          DEFAULT NULL,
  pay_total      decimal(12,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (session_id),
  KEY user_closed (user_id, closed),
  KEY deposit_date (deposit_date)
) ENGINE=MyISAM;

CREATE TABLE ar_activity (
  pid            int(11)       NOT NULL,
  encounter      int(11)       NOT NULL,
  sequence_no    int unsigned  NOT NULL AUTO_INCREMENT,
  code           varchar(9)    NOT NULL            COMMENT 'empty means claim level',
  modifier       varchar(5)    NOT NULL DEFAULT '',
  payer_type     int           NOT NULL            COMMENT '0=pt, 1=ins1, 2=ins2, etc',
  post_time      datetime      NOT NULL,
  post_user      int(11)       NOT NULL            COMMENT 'references users.id',
  session_id     int unsigned  NOT NULL            COMMENT 'references ar_session.session_id',
  memo           varchar(255)  NOT NULL DEFAULT '' COMMENT 'adjustment reasons go here',
  pay_amount     decimal(12,2) NOT NULL DEFAULT 0  COMMENT 'either pay or adj will always be 0',
  adj_amount     decimal(12,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (pid, encounter, sequence_no),
  KEY session_id (session_id)
) ENGINE=MyISAM;
