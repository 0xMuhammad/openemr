<?php
 // Copyright (C) 2006 Rod Roark <rod@sunsetsystems.com>
 //
 // This program is free software; you can redistribute it and/or
 // modify it under the terms of the GNU General Public License
 // as published by the Free Software Foundation; either version 2
 // of the License, or (at your option) any later version.

 // These were adapted from library/classes/Prescription.class.php:

 $form_array = array('', 'suspension', 'tablet', 'capsule', 'solution', 'tsp',
  'ml', 'units', 'inhalations', 'gtts(drops)');

 $unit_array = array('', 'mg', 'mg/1cc', 'mg/2cc', 'mg/3cc', 'mg/4cc',
  'mg/5cc', 'grams', 'mcg');

 $route_array = array('', 'Per Oris', 'Per Rectum', 'To Skin',
  'To Affected Area', 'Sublingual', 'OS', 'OD', 'OU', 'SQ', 'IM', 'IV',
  'Per Nostril');

 $interval_array = array('', 'b.i.d.', 't.i.d.', 'q.i.d.', 'q.3h', 'q.4h',
  'q.5h', 'q.6h', 'q.8h', 'q.d.');

 $interval_array_verbose = array('',
  'twice daily',
  '3 times daily',
  '4 times daily',
  'every 3 hours',
  'every 4 hours',
  'every 5 hours',
  'every 6 hours',
  'every 8 hours',
  'daily');

 $route_array_verbose = array('',
  'by mouth',
  'rectally',
  'to skin',
  'to affected area',
  'under tongue',
  'in left eye',
  'in right eye',
  'in each eye',
  'subcutaneously',
  'intramuscularly',
  'intravenously',
  'in nostril');

 $substitute_array = array('', 'Allowed', 'Not Allowed');
?>
