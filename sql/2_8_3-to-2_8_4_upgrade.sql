ALTER TABLE form_encounter
  ADD billing_note text NOT NULL DEFAULT '';

ALTER TABLE users
  ADD organization varchar(255) NOT NULL DEFAULT '',
  ADD valedictory  varchar(255) NOT NULL DEFAULT '';

ALTER TABLE openemr_postcalendar_events
  ADD pc_facility smallint(6) NOT NULL default '0' COMMENT 'facility id for this event';

ALTER TABLE payments
  ADD encounter bigint(20) NOT NULL DEFAULT 0,
  ADD KEY pid (pid);

ALTER TABLE patient_data
  ADD `usertext1`  varchar(255) NOT NULL DEFAULT '',
  ADD `usertext2`  varchar(255) NOT NULL DEFAULT '',
  ADD `userlist1`  varchar(255) NOT NULL DEFAULT '',
  ADD `userlist2`  varchar(255) NOT NULL DEFAULT '',
  ADD `pricelevel` varchar(255) NOT NULL DEFAULT 'standard';

CREATE TABLE list_options (
  list_id        varchar(31)   NOT NULL,
  option_id      varchar(31)   NOT NULL,
  title          varchar(255)  NOT NULL DEFAULT '',
  seq            int(11)       NOT NULL DEFAULT 0,
  is_default     tinyint(1)    NOT NULL DEFAULT 0,
  option_value   float         NOT NULL DEFAULT 0,
  PRIMARY KEY (list_id, option_id)
) TYPE=MyISAM;

INSERT INTO list_options VALUES ('yesno'  ,'NO' ,'NO' ,1,0,0);
INSERT INTO list_options VALUES ('yesno'  ,'YES','YES',2,0,0);

INSERT INTO list_options VALUES ('titles' ,'Mr.'   ,'Mr.'    ,1,0,0);
INSERT INTO list_options VALUES ('titles' ,'Mrs.'  ,'Mrs.'   ,2,0,0);
INSERT INTO list_options VALUES ('titles' ,'Ms.'   ,'Ms.'    ,3,0,0);
INSERT INTO list_options VALUES ('titles' ,'Dr.'   ,'Dr.'    ,4,0,0);

INSERT INTO list_options VALUES ('sex'    ,'Female','Female' ,1,0,0);
INSERT INTO list_options VALUES ('sex'    ,'Male'  ,'Male'   ,2,0,0);

INSERT INTO list_options VALUES ('marital','married'         ,'Married'         ,1,0,0);
INSERT INTO list_options VALUES ('marital','single'          ,'Single'          ,2,0,0);
INSERT INTO list_options VALUES ('marital','divorced'        ,'Divorced'        ,3,0,0);
INSERT INTO list_options VALUES ('marital','widowed'         ,'Widowed'         ,4,0,0);
INSERT INTO list_options VALUES ('marital','separated'       ,'Separated'       ,5,0,0);
INSERT INTO list_options VALUES ('marital','domestic partner','Domestic Partner',6,0,0);

INSERT INTO list_options VALUES ('language','English','English',1,1,0);
INSERT INTO list_options VALUES ('language','Spanish','Spanish',2,0,0);

INSERT INTO list_options VALUES ('ethrace','Caucasian','Caucasian',1,0,0);
INSERT INTO list_options VALUES ('ethrace','Asian'    ,'Asian'    ,2,0,0);
INSERT INTO list_options VALUES ('ethrace','Black'    ,'Black'    ,3,0,0);
INSERT INTO list_options VALUES ('ethrace','Hispanic' ,'Hispanic' ,4,0,0);

INSERT INTO list_options VALUES ('userlist1','sample','Sample',1,0,0);

INSERT INTO list_options VALUES ('userlist2','sample','Sample',1,0,0);

INSERT INTO list_options VALUES ('pricelevel','standard','Standard',1,1,0);

CREATE TABLE layout_options (
  form_id        varchar(31)   NOT NULL,
  field_id       varchar(31)   NOT NULL,
  group_name     varchar(31)   NOT NULL DEFAULT '',
  title          varchar(63)   NOT NULL DEFAULT '',
  seq            int(11)       NOT NULL DEFAULT 0,
  data_type      tinyint(3)    NOT NULL DEFAULT 0,
  uor            tinyint(1)    NOT NULL DEFAULT 1,
  fld_length     int(11)       NOT NULL DEFAULT 15,
  max_length     int(11)       NOT NULL DEFAULT 0,
  list_id        varchar(31)   NOT NULL DEFAULT '',
  titlecols      tinyint(3)    NOT NULL DEFAULT 1,
  datacols       tinyint(3)    NOT NULL DEFAULT 1,
  default_value  varchar(255)  NOT NULL DEFAULT '',
  edit_options   varchar(36)   NOT NULL DEFAULT '',
  description    varchar(255)  NOT NULL DEFAULT '',
  PRIMARY KEY (form_id, field_id, seq)
) TYPE=MyISAM;

INSERT INTO layout_options VALUES ('DEM','title'          ,'1Who','Name'          , 1, 1,1, 0, 0,'titles' ,1,1,'','' ,'Title');
INSERT INTO layout_options VALUES ('DEM','fname'          ,'1Who',''              , 2, 2,2,10,63,''       ,0,0,'','C','First Name');
INSERT INTO layout_options VALUES ('DEM','mname'          ,'1Who',''              , 3, 2,1, 2,63,''       ,0,0,'','C','Middle Name');
INSERT INTO layout_options VALUES ('DEM','lname'          ,'1Who',''              , 4, 2,2,10,63,''       ,0,0,'','C','Last Name');
INSERT INTO layout_options VALUES ('DEM','pubpid'         ,'1Who','External ID'   , 5, 2,1,10,15,''       ,1,1,'','' ,'External identifier');
INSERT INTO layout_options VALUES ('DEM','DOB'            ,'1Who','DOB'           , 6, 4,2,10,10,''       ,1,1,'','D','Date of Birth');
INSERT INTO layout_options VALUES ('DEM','sex'            ,'1Who','Sex'           , 7, 1,2, 0, 0,'sex'    ,1,1,'','' ,'Sex');
INSERT INTO layout_options VALUES ('DEM','ss'             ,'1Who','S.S.'          , 8, 2,1,11,11,''       ,1,1,'','' ,'Social Security Number');
INSERT INTO layout_options VALUES ('DEM','drivers_license','1Who','License/ID'    , 9, 2,1,15,63,''       ,1,1,'','' ,'Drivers License or State ID');
INSERT INTO layout_options VALUES ('DEM','status'         ,'1Who','Marital Status',10, 1,1, 0, 0,'marital',1,3,'','' ,'Marital Status');
INSERT INTO layout_options VALUES ('DEM','genericname1'   ,'1Who','User Defined'  ,11, 2,1,15,63,''       ,1,3,'','' ,'User Defined Field');
INSERT INTO layout_options VALUES ('DEM','genericval1'    ,'1Who',''              ,12, 2,1,15,63,''       ,0,0,'','' ,'User Defined Field');
INSERT INTO layout_options VALUES ('DEM','genericname2'   ,'1Who',''              ,13, 2,1,15,63,''       ,0,0,'','' ,'User Defined Field');
INSERT INTO layout_options VALUES ('DEM','genericval2'    ,'1Who',''              ,14, 2,1,15,63,''       ,0,0,'','' ,'User Defined Field');
INSERT INTO layout_options VALUES ('DEM','squad'          ,'1Who','Squad'         ,15,13,0, 0, 0,''       ,1,3,'','' ,'Squad Membership');
INSERT INTO layout_options VALUES ('DEM','pricelevel'     ,'1Who','Price Level'   ,16, 1,0, 0, 0,'pricelevel',1,1,'','' ,'Discount Level');

INSERT INTO layout_options VALUES ('DEM','street'              ,'2Contact','Address'          , 1, 2,1,25,63,''     ,1,1,'','C','Street and Number');
INSERT INTO layout_options VALUES ('DEM','city'                ,'2Contact','City'             , 2, 2,1,15,63,''     ,1,1,'','C','City Name');
INSERT INTO layout_options VALUES ('DEM','state'               ,'2Contact','State'            , 3, 2,1,15,63,''     ,1,1,'','C','State/Locality');
INSERT INTO layout_options VALUES ('DEM','postal_code'         ,'2Contact','Postal Code'      , 4, 2,1, 6,63,''     ,1,1,'','' ,'Postal Code');
INSERT INTO layout_options VALUES ('DEM','country_code'        ,'2Contact','Country'          , 5, 1,1, 0, 0,'country',1,1,'','','Country');
INSERT INTO layout_options VALUES ('DEM','contact_relationship','2Contact','Emergency Contact', 6, 2,1,10,63,''     ,1,1,'','C','Emergency Contact Person');
INSERT INTO layout_options VALUES ('DEM','phone_contact'       ,'2Contact','Emergency Phone'  , 7, 2,1,20,63,''     ,1,1,'','P','Emergency Contact Phone Number');
INSERT INTO layout_options VALUES ('DEM','phone_home'          ,'2Contact','Home Phone'       , 8, 2,1,20,63,''     ,1,1,'','P','Home Phone Number');
INSERT INTO layout_options VALUES ('DEM','phone_biz'           ,'2Contact','Work Phone'       , 9, 2,1,20,63,''     ,1,1,'','P','Work Phone Number');
INSERT INTO layout_options VALUES ('DEM','phone_cell'          ,'2Contact','Mobile Phone'     ,10, 2,1,20,63,''     ,1,1,'','P','Cell Phone Number');
INSERT INTO layout_options VALUES ('DEM','email'               ,'2Contact','Contact Email'    ,11, 2,1,30,95,''     ,1,1,'','' ,'Contact Email Address');

INSERT INTO layout_options VALUES ('DEM','providerID'   ,'3Choices','Provider'             , 1,11,2, 0, 0,''       ,1,3,'','' ,'Referring Provider');
INSERT INTO layout_options VALUES ('DEM','pharmacy_id'  ,'3Choices','Pharmacy'             , 2,12,1, 0, 0,''       ,1,3,'','' ,'Preferred Pharmacy');
INSERT INTO layout_options VALUES ('DEM','hipaa_notice' ,'3Choices','HIPAA Notice Received', 3, 1,1, 0, 0,'yesno'  ,1,1,'','' ,'Did you receive a copy of the HIPAA Notice?');
INSERT INTO layout_options VALUES ('DEM','hipaa_voice'  ,'3Choices','Allow Voice Message'  , 4, 1,1, 0, 0,'yesno'  ,1,1,'','' ,'Allow telephone messages?');
INSERT INTO layout_options VALUES ('DEM','hipaa_mail'   ,'3Choices','Allow Mail Message'   , 5, 1,1, 0, 0,'yesno'  ,1,1,'','' ,'Allow email messages?');
INSERT INTO layout_options VALUES ('DEM','hipaa_message','3Choices','Leave Message With'   , 6, 2,1,20,63,''       ,1,1,'','' ,'With whom may we leave a message?');

INSERT INTO layout_options VALUES ('DEM','occupation'    ,'4Employer','Occupation'      , 1, 2,1,20,63,''     ,1,1,'','C','Occupation');
INSERT INTO layout_options VALUES ('DEM','em_name'       ,'4Employer','Employer Name'   , 2, 2,1,20,63,''     ,1,1,'','C','Employer Name');
INSERT INTO layout_options VALUES ('DEM','em_street'     ,'4Employer','Employer Address', 3, 2,1,25,63,''     ,1,1,'','C','Street and Number');
INSERT INTO layout_options VALUES ('DEM','em_city'       ,'4Employer','City'            , 4, 2,1,15,63,''     ,1,1,'','C','City Name');
INSERT INTO layout_options VALUES ('DEM','em_state'      ,'4Employer','State'           , 5, 2,1,15,63,''     ,1,1,'','C','State/Locality');
INSERT INTO layout_options VALUES ('DEM','em_postal_code','4Employer','Postal Code'     , 6, 2,1, 6,63,''     ,1,1,'','' ,'Postal Code');
INSERT INTO layout_options VALUES ('DEM','em_country'    ,'4Employer','Country'         , 7, 2,1,10,63,''     ,1,1,'','C','Country');

INSERT INTO layout_options VALUES ('DEM','language'        ,'5Stats','Language'             , 1, 1,1, 0, 0,'language',1,1,'','' ,'Preferred Language');
INSERT INTO layout_options VALUES ('DEM','ethnoracial'     ,'5Stats','Race/Ethnicity'       , 2, 1,1, 0, 0,'ethrace' ,1,1,'','' ,'Ethnicity or Race');
INSERT INTO layout_options VALUES ('DEM','financial_review','5Stats','Financial Review Date', 3, 2,1,10,10,''        ,1,1,'','D','Financial Review Date');
INSERT INTO layout_options VALUES ('DEM','family_size'     ,'5Stats','Family Size'          , 4, 2,1,20,63,''        ,1,1,'','' ,'Family Size');
INSERT INTO layout_options VALUES ('DEM','monthly_income'  ,'5Stats','Monthly Income'       , 5, 2,1,20,63,''        ,1,1,'','' ,'Monthly Income');
INSERT INTO layout_options VALUES ('DEM','homeless'        ,'5Stats','Homeless, etc.'       , 6, 2,1,20,63,''        ,1,1,'','' ,'Homeless or similar?');
INSERT INTO layout_options VALUES ('DEM','interpretter'    ,'5Stats','Interpreter'          , 7, 2,1,20,63,''        ,1,1,'','' ,'Interpreter needed?');
INSERT INTO layout_options VALUES ('DEM','migrantseasonal' ,'5Stats','Migrant/Seasonal'     , 8, 2,1,20,63,''        ,1,1,'','' ,'Migrant or seasonal worker?');

INSERT INTO layout_options VALUES ('DEM','usertext1'       ,'6Misc','User Defined Text 1'   , 1, 2,0,10,63,''         ,1,1,'','' ,'User Defined');
INSERT INTO layout_options VALUES ('DEM','usertext2'       ,'6Misc','User Defined Text 2'   , 2, 2,0,10,63,''         ,1,1,'','' ,'User Defined');
INSERT INTO layout_options VALUES ('DEM','userlist1'       ,'6Misc','User Defined List 1'   , 3, 1,0, 0, 0,'userlist1',1,1,'','' ,'User Defined');
INSERT INTO layout_options VALUES ('DEM','userlist2'       ,'6Misc','User Defined List 2'   , 4, 1,0, 0, 0,'userlist2',1,1,'','' ,'User Defined');

ALTER TABLE transactions
  ADD `refer_date`              date         DEFAULT NULL,
  ADD `refer_from`              int(11)      NOT NULL DEFAULT 0,
  ADD `refer_to`                int(11)      NOT NULL DEFAULT 0,
  ADD `refer_diag`              varchar(255) NOT NULL DEFAULT '',
  ADD `refer_risk_level`        varchar(255) NOT NULL DEFAULT '',
  ADD `refer_vitals`            tinyint(1)   NOT NULL DEFAULT 0,
  ADD `reply_date`              date         DEFAULT NULL,
  ADD `reply_from`              varchar(255) NOT NULL DEFAULT '',
  ADD `reply_init_diag`         varchar(255) NOT NULL DEFAULT '',
  ADD `reply_final_diag`        varchar(255) NOT NULL DEFAULT '',
  ADD `reply_documents`         varchar(255) NOT NULL DEFAULT '',
  ADD `reply_findings`          text         NOT NULL DEFAULT '',
  ADD `reply_services`          text         NOT NULL DEFAULT '',
  ADD `reply_recommend`         text         NOT NULL DEFAULT '',
  ADD `reply_rx_refer`          text         NOT NULL DEFAULT '';

INSERT INTO layout_options VALUES ('REF','refer_date'      ,'1Referral','Referral Date'                  , 1, 4,2, 0,  0,''         ,1,1,'C','D','Date of referral');
INSERT INTO layout_options VALUES ('REF','refer_from'      ,'1Referral','Refer By'                       , 2,10,2, 0,  0,''         ,1,1,'' ,'' ,'Referral By');
INSERT INTO layout_options VALUES ('REF','refer_to'        ,'1Referral','Refer To'                       , 3,14,2, 0,  0,''         ,1,1,'' ,'' ,'Referral To');
INSERT INTO layout_options VALUES ('REF','body'            ,'1Referral','Reason'                         , 4, 3,2,30,  3,''         ,1,1,'' ,'' ,'Reason for referral');
INSERT INTO layout_options VALUES ('REF','refer_external'  ,'1Referral','External Referral'              , 5, 1,1, 0,  0,'boolean'  ,1,1,'' ,'' ,'External referral?');
INSERT INTO layout_options VALUES ('REF','refer_diag'      ,'1Referral','Referrer Diagnosis'             , 6, 2,1,30,255,''         ,1,1,'' ,'X','Referrer diagnosis');
INSERT INTO layout_options VALUES ('REF','refer_risk_level','1Referral','Risk Level'                     , 7, 1,1, 0,  0,'risklevel',1,1,'' ,'' ,'Level of urgency');
INSERT INTO layout_options VALUES ('REF','refer_vitals'    ,'1Referral','Include Vitals'                 , 8, 1,1, 0,  0,'boolean'  ,1,1,'' ,'' ,'Include vitals data?');
INSERT INTO layout_options VALUES ('REF','reply_date'      ,'2Counter-Referral','Reply Date'             , 9, 4,1, 0,  0,''         ,1,1,'' ,'D','Date of reply');
INSERT INTO layout_options VALUES ('REF','reply_from'      ,'2Counter-Referral','Reply From'             ,10, 2,1,30,255,''         ,1,1,'' ,'' ,'Who replied?');
INSERT INTO layout_options VALUES ('REF','reply_init_diag' ,'2Counter-Referral','Presumed Diagnosis'     ,11, 2,1,30,255,''         ,1,1,'' ,'' ,'Presumed diagnosis by specialist');
INSERT INTO layout_options VALUES ('REF','reply_final_diag','2Counter-Referral','Final Diagnosis'        ,12, 2,1,30,255,''         ,1,1,'' ,'' ,'Final diagnosis by specialist');
INSERT INTO layout_options VALUES ('REF','reply_documents' ,'2Counter-Referral','Documents'              ,13, 2,1,30,255,''         ,1,1,'' ,'' ,'Where may related scanned or paper documents be found?');
INSERT INTO layout_options VALUES ('REF','reply_findings'  ,'2Counter-Referral','Findings'               ,14, 3,1,30,  3,''         ,1,1,'' ,'' ,'Findings by specialist');
INSERT INTO layout_options VALUES ('REF','reply_services'  ,'2Counter-Referral','Services Provided'      ,15, 3,1,30,  3,''         ,1,1,'' ,'' ,'Service provided by specialist');
INSERT INTO layout_options VALUES ('REF','reply_recommend' ,'2Counter-Referral','Recommendations'        ,16, 3,1,30,  3,''         ,1,1,'' ,'' ,'Recommendations by specialist');
INSERT INTO layout_options VALUES ('REF','reply_rx_refer'  ,'2Counter-Referral','Prescriptions/Referrals',17, 3,1,30,  3,''         ,1,1,'' ,'' ,'Prescriptions and/or referrals by specialist');

INSERT INTO list_options VALUES ('risklevel','low'   ,'Low'   ,1,0,0);
INSERT INTO list_options VALUES ('risklevel','medium','Medium',2,1,0);
INSERT INTO list_options VALUES ('risklevel','high'  ,'High'  ,3,0,0);

INSERT INTO list_options VALUES ('boolean','0','No' ,1,0,0);
INSERT INTO list_options VALUES ('boolean','1','Yes',2,0,0);

ALTER TABLE codes
  ADD related_code varchar(255)  NOT NULL DEFAULT '' COMMENT 'may reference a related codes.code';

CREATE TABLE prices (
  pr_id          varchar(11)   NOT NULL            COMMENT 'references codes.id or drugs.id',
  pr_selector    varchar(15)   NOT NULL DEFAULT '' COMMENT 'template selector for drugs, empty for codes',
  pr_level       varchar(31)   NOT NULL DEFAULT '' COMMENT 'price level',
  pr_price       decimal(12,2) NOT NULL DEFAULT 0  COMMENT 'price in local currency',
  PRIMARY KEY (pr_id, pr_selector, pr_level)
) TYPE=MyISAM;

INSERT INTO prices ( pr_id, pr_level, pr_price )
  SELECT codes.id, 'standard', codes.fee FROM codes
  WHERE codes.fee IS NOT NULL AND codes.fee > 0;

ALTER TABLE codes
  ADD taxrates varchar(255) NOT NULL DEFAULT '' COMMENT 'tax rate names delimited by colons';

ALTER TABLE drug_templates
  ADD taxrates varchar(255) NOT NULL DEFAULT '' COMMENT 'tax rate names delimited by colons';

ALTER TABLE drug_sales
  ADD billed tinyint(1) NOT NULL DEFAULT 0 COMMENT 'indicates if the sale is posted to accounting';
UPDATE drug_sales
  SET billed = 1 WHERE encounter > 0;

ALTER TABLE form_encounter
  ADD pc_catid int(11) NOT NULL DEFAULT 5 COMMENT 'event category from openemr_postcalendar_categories';

CREATE TABLE fee_sheet_options (
  fs_category varchar(63)  NOT NULL DEFAULT '' COMMENT 'Descriptive category name',
  fs_option   varchar(63)  NOT NULL DEFAULT '' COMMENT 'Descriptive option name',
  fs_codes    varchar(255) NOT NULL DEFAULT '' COMMENT 'multiple instances of type:id:selector;'
) TYPE=MyISAM;
INSERT INTO fee_sheet_options VALUES ('1New Patient','1Brief'  ,'CPT4|99201|');
INSERT INTO fee_sheet_options VALUES ('1New Patient','2Limited','CPT4|99202|');
INSERT INTO fee_sheet_options VALUES ('1New Patient','3Detailed','CPT4|99203|');
INSERT INTO fee_sheet_options VALUES ('1New Patient','4Extended','CPT4|99204|');
INSERT INTO fee_sheet_options VALUES ('1New Patient','5Comprehensive','CPT4|99205|');
INSERT INTO fee_sheet_options VALUES ('2Established Patient','1Brief'  ,'CPT4|99211|');
INSERT INTO fee_sheet_options VALUES ('2Established Patient','2Limited','CPT4|99212|');
INSERT INTO fee_sheet_options VALUES ('2Established Patient','3Detailed','CPT4|99213|');
INSERT INTO fee_sheet_options VALUES ('2Established Patient','4Extended','CPT4|99214|');
INSERT INTO fee_sheet_options VALUES ('2Established Patient','5Comprehensive','CPT4|99215|');

ALTER TABLE `users`
  ADD COLUMN `cal_ui` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Specifies calendar display style';

ALTER TABLE drugs
  ADD related_code varchar(255)  NOT NULL DEFAULT '' COMMENT 'may reference a related codes.code';

ALTER TABLE billing
  MODIFY `justify` varchar(255) NOT NULL DEFAULT '';

ALTER TABLE prescriptions
  MODIFY `quantity` varchar(31) default '';

ALTER TABLE codes
  MODIFY `superbill` varchar(31) default '';
INSERT INTO list_options VALUES ('superbill','newpt','New Patient'        ,1,0,0);
INSERT INTO list_options VALUES ('superbill','estpt','Established Patient',2,0,0);

ALTER TABLE patient_data
  ADD `userlist3`  varchar(255) NOT NULL DEFAULT '',
  ADD `userlist4`  varchar(255) NOT NULL DEFAULT '',
  ADD `userlist5`  varchar(255) NOT NULL DEFAULT '',
  ADD `userlist6`  varchar(255) NOT NULL DEFAULT '',
  ADD `userlist7`  varchar(255) NOT NULL DEFAULT '',
  ADD `regdate`    date DEFAULT NULL COMMENT 'Registration Date';

INSERT INTO list_options VALUES ('userlist3','sample','Sample',1,0,0);
INSERT INTO list_options VALUES ('userlist4','sample','Sample',1,0,0);
INSERT INTO list_options VALUES ('userlist5','sample','Sample',1,0,0);
INSERT INTO list_options VALUES ('userlist6','sample','Sample',1,0,0);
INSERT INTO list_options VALUES ('userlist7','sample','Sample',1,0,0);

INSERT INTO layout_options VALUES ('DEM','userlist3'       ,'6Misc','User Defined List 3'   , 5, 1,0, 0, 0,'userlist3',1,1,'','' ,'User Defined');
INSERT INTO layout_options VALUES ('DEM','userlist4'       ,'6Misc','User Defined List 4'   , 6, 1,0, 0, 0,'userlist4',1,1,'','' ,'User Defined');
INSERT INTO layout_options VALUES ('DEM','userlist5'       ,'6Misc','User Defined List 5'   , 7, 1,0, 0, 0,'userlist5',1,1,'','' ,'User Defined');
INSERT INTO layout_options VALUES ('DEM','userlist6'       ,'6Misc','User Defined List 6'   , 8, 1,0, 0, 0,'userlist6',1,1,'','' ,'User Defined');
INSERT INTO layout_options VALUES ('DEM','userlist7'       ,'6Misc','User Defined List 7'   , 9, 1,0, 0, 0,'userlist7',1,1,'','' ,'User Defined');
INSERT INTO layout_options VALUES ('DEM','regdate'         ,'6Misc','Registration Date'     ,10, 4,0,10,10,''         ,1,1,'','D','Start Date at This Clinic');

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

INSERT INTO list_options VALUES ('country','USA','USA',1,0,0);

ALTER TABLE patient_data ADD `contrastart` date DEFAULT NULL COMMENT 'Date contraceptives initially used';
INSERT INTO layout_options VALUES ('DEM','contrastart','5Stats','Contraceptives Start',9,2,0,10,10,'',1,1,'','D','Date contraceptive services initially provided');

ALTER TABLE transactions
  ADD `refer_external`          tinyint(1)   NOT NULL DEFAULT 0;
