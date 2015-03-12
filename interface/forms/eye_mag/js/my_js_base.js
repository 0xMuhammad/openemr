/**
 * forms/eye_mag/js/my_js_base.js
 *
 * JS Functions for eye_mag form(s)
 *
 * Copyright (C) 2010-14 Raymond Magauran <magauran@MedFetch.com>
 *
 * LICENSE: This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://opensource.org/licenses/gpl-license.php>;.
 *
 * @package OpenEMR
 * @author Ray Magauran <magauran@MedFetch.com>
 * @link http://www.open-emr.org
 */


/**
 *  Function to add a Quick Pick selection/value to the corresponding text field.
 *  If the the field we are writing to has a default value in it, erase it, otherwise add to it.
 *  Since Default values give the field a bgcolor of rgb(245, 245, 220), we can use that.  OK for now.
 *  In the future, we can make an array of default values an see if this matches the fields current value.
 */
function fill_QP_field(PEZONE, ODOSOU, LOCATION_text, selection,mult) {
    if (ODOSOU > '') {
        var FIELDID =  ODOSOU  + LOCATION_text;
    } else {
        var FIELDID =  document.getElementById(PEZONE+'_'+ODOSOU).value  + LOCATION_text;
    }
    var bgcolor = $("#" +FIELDID).css("background-color");
    var prefix = document.getElementById(PEZONE+'_prefix').value;
    var Fvalue = document.getElementById(FIELDID).value;
    if (prefix > '' && prefix !='off') {prefix = prefix + " ";}
    if (prefix =='off') { prefix=''; }
    if (($("#" +FIELDID).css("background-color")=="rgb(245, 245, 220)") || (Fvalue ==''))  {
        $("#" +FIELDID).val(prefix+selection);
        $("#" +FIELDID).css("background-color","#C0C0C0");
    } else {
        if (Fvalue >'') prefix = ", "+prefix;
        $("#" +FIELDID).val(Fvalue + prefix +selection);
        $("#" +FIELDID).css("background-color","#C0C0C0");
            //$("#" +FIELDID).css("background-color","red");
    }
    submit_form(FIELDID);
}

function clear_vars() {
    document.eye_mag.var1.value = "white";
    document.eye_mag.var2.value = "white";
}

function dopopup(url) {
    top.restoreSession();
    window.open(url, '_blank', 'directories=0,titlebar=0,toolbar=0,location=0,status=0,menubar=0');
}

function submit_form(e) {
    var url = "../../forms/eye_mag/save.php?mode=update&id=" + $("#form_id").val();
    var formData = $("form#eye_mag").serialize();
    
    $.ajax({
           type 	: 'POST',   // define the type of HTTP verb we want to use (POST for our form)
           url 		: url,      // the url where we want to POST
           data 	: formData, // our data object
           success  : function(result)  {
           $("#tellme").html(result);
           }
           });
        //    refreshme();
}

/**
 *  Function to update the user's preferences
 */
function update_PREFS() {
    var url = "../../forms/eye_mag/save.php";
    var formData = {
        'AJAX_PREFS'            : "1",
        'PREFS_VA'              : $('#PREFS_VA').val(),
        'PREFS_W'               : $('#PREFS_W').val(),
        'PREFS_MR'              : $('#PREFS_MR').val(),
        'PREFS_CR'              : $('#PREFS_CR').val(),
        'PREFS_CTL'             : $('#PREFS_CTL').val(),
        'PREFS_ADDITIONAL'      : $('#PREFS_ADDITIONAL').val(),
        'PREFS_CLINICAL'        : $('#PREFS_CLINICAL').val(),
        'PREFS_EXAM'            : $('#PREFS_EXAM').val(),
        'PREFS_CYL'             : $('#PREFS_CYL').val(),
        'PREFS_EXT_VIEW'        : $('#PREFS_EXT_VIEW').val(),
        'PREFS_ANTSEG_VIEW'     : $('#PREFS_ANTSEG_VIEW').val(),
        'PREFS_RETINA_VIEW'     : $('#PREFS_RETINA_VIEW').val(),
        'PREFS_NEURO_VIEW'      : $('#PREFS_NEURO_VIEW').val(),
        'PREFS_ACT_VIEW'        : $('#PREFS_ACT_VIEW').val(),
        'PREFS_ACT_SHOW'        : $('#PREFS_ACT_SHOW').val()
    };
    $.ajax({
           type 		: 'POST',
           url          : url,
           data 		: formData,
           success      : function(result) {
           $("#tellme").html(result);
           }
           });
}

function show_right() {
    $("#EXT_sections").removeClass("size50").addClass("size100");
    $("#ANTSEG_sections").removeClass("size50").addClass("size100");
    $("#NEURO_sections").removeClass("size50").addClass("size100");
    $("#RETINA_sections").removeClass("size50").addClass("size100");
    $("#EXT_right").removeClass("nodisplay");
    $("#ANTSEG_right").removeClass("nodisplay");
    $("#NEURO_right").removeClass("nodisplay");
    $("#RETINA_right").removeClass("nodisplay");
    $("#ANTSEG_sections").addClass("clear_both");
    $("#RETINA_sections").addClass("clear_both");
    $("#NEURO_sections").addClass("clear_both");
    hide_PRIORS();
}
function hide_right() {
    $("#EXT_sections").removeClass("size100").addClass("size50");
    $("#ANTSEG_sections").removeClass("size100").addClass("size50");
    $("#NEURO_sections").removeClass("size100").addClass("size50");
    $("#RETINA_sections").removeClass("size100").addClass("size50");
    $("#EXT_right").addClass("nodisplay");
    $("#ANTSEG_right").addClass("nodisplay");
    $("#NEURO_right").addClass("nodisplay");
    $("#RETINA_right").addClass("nodisplay");
    $("#ANTSEG_sections").removeClass("clear_both");
    $("#RETINA_sections").removeClass("clear_both");
    $("#NEURO_sections").removeClass("clear_both");
}

function show_DRAW() {
    hide_QP();
    hide_TEXT();
    hide_PRIORS();
    $("#LayerTechnical_sections").hide();
    $("#REFRACTION_sections").hide();
    $("#VISION_sections").hide();
    $("#NEURO_sections").hide();
    $("#EXT_left").addClass('canvas');
    $("#EXT_right").addClass('canvas');
    $("#ANTSEG_left").addClass('canvas');
    $("#ANTSEG_right").addClass('canvas');
    $("#RETINA_left").addClass('canvas');
    $("#RETINA_right").addClass('canvas');
    $("#IMPPLAN").hide();
    $(".Draw_class").show();
}
function show_TEXT() {
    hide_right(); //this hides the right half
    hide_QP();
    hide_DRAW();
    hide_PRIORS();
    $("#NEURO_sections").show();
    $(".TEXT_class").show();
}
function show_PRIORS() {
    $("#NEURO_sections").show();
    hide_QP();
    hide_DRAW();
    $("#EXT_right").addClass("PRIORS_color");
    show_TEXT();
    show_right();
    $("#EXT_right").addClass('canvas');
    $("#ANTSEG_right").addClass('canvas');
    $("#RETINA_right").addClass('canvas');
    $("#NEURO_right").addClass('canvas');
    $(".PRIORS_class").show();
}

function show_QP() {
    hide_DRAW();
    hide_PRIORS();
    show_TEXT();
    show_right();
    $("#EXT_right").addClass('canvas');
    $("#ANTSEG_right").addClass('canvas');
    $("#RETINA_right").addClass('canvas');
    $("#NEURO_right").addClass('canvas');
    $(".QP_class").show();
}
function hide_DRAW() {
    $(".Draw_class").hide();
    $("#LayerTechnical_sections").show();
    $("#REFRACTION_sections").show();
    $("#VISION_sections").show();
    $("#NEURO_sections").show();
    $("#IMPPLAN").show();
    $("#EXT_left").removeClass('canvas');
    $("#EXT_right").removeClass('canvas');
    $("#RETINA_left").removeClass('canvas');
    $("#RETINA_right").removeClass('canvas');
    $("#ANTSEG_left").removeClass('canvas');
    $("#ANTSEG_right").removeClass('canvas');
}
function hide_QP() {
    $(".QP_class").hide();
    $("#EXT_right").removeClass('canvas');
    $("#ANTSEG_right").removeClass('canvas');
    $("#RETINA_right").removeClass('canvas');
    $("#NEURO_right").removeClass('canvas');
}
function hide_TEXT() {
    $(".TEXT_class").hide();
}
function hide_PRIORS() {
    $(".PRIORS_class").hide();
    $("#EXT_right").removeClass("PRIORS_color");
    
    /*  $("#PRIORS_EXT_left_text").addClass("nodisplay");
     $("#PRIORS_ANTSEG_left_text").addClass("nodisplay");
     $("#PRIORS_RETINA_left_text").addClass("nodisplay");
     $("#PRIORS_NEURO_left_text").addClass("nodisplay");
     */
}

function printElem(options){
    var pat = $("#pat_name").html();
    $("#wearing_title").html("<h2>Eye Prescription</h2><span style='text-align:left;font-weight:bold;'>NAME: </span><u>"+pat+"</u>");
    $("#signature_W").toggleClass('nodisplay');
    $("#simplePrint").toggleClass('nodisplay');
    $('#wearing').printElement(options);
    $("#wearing_title").html("Current Rx");
    $("#signature_W").toggleClass('nodisplay');
    $("#simplePrint").toggleClass('nodisplay');
}
function toggle_visibility(id) {
    var e = document.getElementById(id);
    if(e.style.display == 'block')
        e.style.display = 'none';
    else
        e.style.display = 'block';
}
    // plot the current graph
    //------------------------------------------------------
function plot_graph(checkedBoxes, theitems, thetrack, thedates, thevalues, trackCount){
    top.restoreSession();
    return $.ajax({ url: '/openemr/library/openflashchart/graph_track_anything.php',
                  type: 'POST',
                  data: {
                    dates:  thedates,   //$the_date_array
                    values: thevalues,  //$the_value_array
                    items:  theitems,   //$the_item_names
                    track:  thetrack,   //$titleGraph
                    thecheckboxes: checkedBoxes //$the_checked_cols
                  },
                  dataType: "json",
                  success: function(returnData){
                  // ofc will look after a variable named "ofc"
                  // inside of the flashvar
                  // However, we need to set both
                  // data and flashvars.ofc
                  data=returnData;
                  flashvars.ofc = returnData;
                  // call ofc with proper falshchart
                  swfobject.embedSWF('/openemr/library/openflashchart/open-flash-chart.swf',
                                     "graph"+trackCount, "650", "200", "9.0.0","",flashvars);
                  },
                  error: function (XMLHttpRequest, textStatus, errorThrown) {
                  alert(XMLHttpRequest.responseText);
                  //alert("XMLHttpRequest="+XMLHttpRequest.responseText+"\ntextStatus="+textStatus+"\nerrorThrown="+errorThrown);
                  }
                  
                  }); // end ajax query	
}
function openImage() {
        //var f = document.forms[0];
        //var tmp = (keyid && f.form_key[1].checked) ? ('?enclink=' + keyid) : '';
    dlgopen('/openemr/controller.php?document&retrieve&patient_id=3&document_id=10&as_file=false', '_blank', 600, 475);
}

function show_Section(section) {
        //hide everything, show the section.  For fullscreen perhaps Tablet view per section
    $('#form_container').hide();
    $('#'+section).appendTo('body');
}
$(document).ready(function() {
                  $("[id^='CONSTRUCTION_']").toggleClass('nodisplay');
                  $("input,select,textarea,text").css("background-color","#FFF8DC");
                  $("#IOPTIME").css("background-color","#FFFFFF");
                  $("#refraction_width").css("width","8.5in");
                  $(".Draw_class").hide();
                  hide_DRAW();
                  $(window).resize(function() {
                                   if (window.innerWidth >'900') {
                                   $("#refraction_width").css("width","8.5in");
                                   $("#LayerVision2").css("padding","4px");
                                   }
                                   if (window.innerWidth >'1200') {
                                   $("#refraction_width").css("width","12.8in");
                                   $("#LayerVision2").css("padding","4px");
                                   }
                                   if (window.innerWidth >'1900') {
                                   $("#refraction_width").css("width","16.8in");
                                   $("#LayerVision2").css("padding","4px");
                                   }
                                   
                                   });
                  $(window).resize();
                  //  $("#PRIOR_ALL").val("128").trigger("change");
                  var hash_tag = '<i class="fa fa-minus"></i>';
                  var index;
                  $("#MOTILITY_RS").value = parseInt($("#MOTILITY_RS").val());
                  if ($("#MOTILITY_RS").val() > '0') {
                  $("#MOTILITYNORMAL").removeAttr('checked');
                  for (index =1; index <= ($("#MOTILITY_RS").val()); ++index) {
                  $("#MOTILITY_RS_"+index).html(hash_tag);
                  }
                  }
                  $("#MOTILITY_RI").value = parseInt($("#MOTILITY_RI").val());
                  if ($("#MOTILITY_RI").val() > '0') {
                  $("#MOTILITYNORMAL").removeAttr('checked');
                  for (index =1; index <= ($("#MOTILITY_RI").val()); ++index) {
                  $("#MOTILITY_RI_"+index).html(hash_tag);
                  }
                  }
                  $("#MOTILITY_LS").value = parseInt($("#MOTILITY_LS").val());
                  if ($("#MOTILITY_LS").val() > '0') {
                  $("#MOTILITYNORMAL").removeAttr('checked');
                  for (index =1; index <= ($("#MOTILITY_LS").val()); ++index) {
                  $("#MOTILITY_LS_"+index).html(hash_tag);
                  }
                  }
                  $("#MOTILITY_LI").value = parseInt($("#MOTILITY_LI").val());
                  if ($("#MOTILITY_LI").val() > '0') {
                  $("#MOTILITYNORMAL").removeAttr('checked');
                  for (index =1; index <= ($("#MOTILITY_LI").val()); ++index) {
                  $("#MOTILITY_LI_"+index).html(hash_tag);
                  }
                  }
                  
                  var hash_tag = '<i class="fa fa-minus rotate-left"></i>';
                  $("#MOTILITY_LR").value = parseInt($("#MOTILITY_LR").val());
                  if ($("#MOTILITY_LR").val() > '0') {
                  $("#MOTILITYNORMAL").removeAttr('checked');
                  for (index =1; index <= ($("#MOTILITY_LR").val()); ++index) {
                  $("#MOTILITY_LR_"+index).html(hash_tag);
                  }
                  }
                  $("#MOTILITY_LL").value = parseInt($("#MOTILITY_LL").val());
                  if ($("#MOTILITY_LL").val() > '0') {
                  $("#MOTILITYNORMAL").removeAttr('checked');
                  for (index =1; index <= ($("#MOTILITY_LL").val()); ++index) {
                  $("#MOTILITY_LL_"+index).html(hash_tag);
                  }
                  }
                  $("#MOTILITY_RR").value = parseInt($("#MOTILITY_RR").val());
                  if ($("#MOTILITY_RR").val() > '0') {
                  $("#MOTILITYNORMAL").removeAttr('checked');
                  for (index =1; index <= ($("#MOTILITY_RR").val()); ++index) {
                  $("#MOTILITY_RR_"+index).html(hash_tag);
                  }
                  }
                  $("#MOTILITY_RL").value = parseInt($("#MOTILITY_RL").val());
                  if ($("#MOTILITY_RL").val() > '0') {
                  $("#MOTILITYNORMAL").removeAttr('checked');
                  for (index =1; index <= ($("#MOTILITY_RL").val()); ++index) {
                  $("#MOTILITY_RL_"+index).html(hash_tag);
                  }
                  }
                  
                  
                  $("input[name$='PRISM']").blur(function() {
                                                 //make it all caps
                                                 var str = $(this).val();
                                                 str = str.toUpperCase();
                                                 $(this).val(str);
                                                 });
                  $("input[name$='SPH']").blur(function() {
                                               var mid = $(this).val();
                                               if (!mid.match(/\./)) {
                                               var front = mid.match(/([\+\-]?\d{0,2})(\d{2})/)[1];
                                               var back  = mid.match(/(\d{0,2})(\d{2})/)[2];
                                               mid = front + "." + back;
                                               }
                                               if (!mid.match(/^(\+|\-){1}/)) {
                                               mid = "+" + mid;
                                               }
                                               $(this).val(mid);
                                               });
                  $("input[name$='ADD']").blur(function() {
                                               var add = $(this).val();
                                               if (!add.match(/\./)) {
                                               var front = add.match(/([\+\-]?\d{0,2})(\d{2})/)[1];
                                               var back  = add.match(/(\d{0,2})(\d{2})/)[2];
                                               add = front + "." + back;
                                               }
                                               if (!add.match(/^(\+|\-){1}/)) {
                                               add = "+" + add;
                                               }
                                               $(this).val(add);
                                               submit_form();
                                               });
                  
                  $("[name$='AXIS']").blur(function() {
                                           //hmmn.  Make this a 3 digit leading zeros number.
                                           // we are no translating text to numbers, just numbers to
                                           // a 3 digit format with leading zeroes as needed.
                                           // assume there are nly letters presented and the end use KNOWS
                                           // more than 3 digits is a mistake...
                                           var axis = $(this).val();
                                           // if (!axis.match(/\d/)) return;
                                           if (!axis.match(/\d\d\d/)) {
                                            if (!axis.match(/\d\d/)) {
                                                if (!axis.match(/\d/)) {
                                                    axis = '0';
                                                }
                                                axis = '0' + axis;
                                            }
                                           axis = '0' + axis;
                                           
                                           }
                                           });

                  
                  $("[name$='CYL']").blur(function() {
                                          var mid = $(this).val();
                                          if (!mid.match(/\./)) {
                                            var front = mid.match(/([\+\-]?\d{0,2})(\d{2})/)[1];
                                            var back  = mid.match(/(\d{0,2})(\d{2})/)[2];
                                            mid = front + "." + back;
                                          }
                                          //if mid is -2.5 make it -2.50
                                          if (mid.match(/\.\d$/)) {
                                           mid = mid + '0';
                                          // mid = this.val() + '0';
                                          }
                                          $(this).val(mid);
                                          if (!$('#PREFS_CYL').val()) {
                                          $('#PREFS_CYL').val('+');
                                          update_PREFS();
                                          }
                                          
                                          if (!mid.match(/^(\+|\-){1}/)) {
                                          //no +/- sign in the field
                                          //ok so there is a preference set
                                          //if it doesn't start with + or - then give it the preference value
                                          var plusminus = $('#PREFS_CYL').val() + mid;
                                          $(this).val(plusminus);  //set this cyl value to plusminus
                                          } else if (mid.match(/^(\+|\-){1}/)) {
                                          midmatch = mid.match(/^(\+|\-){1}/)[0];
                                          $(this).val(mid);
                                          $('#PREFS_CYL').val(midmatch);
                                          update_PREFS();
                                          //so they used a value + or - in the field.
                                          //The only reason to work on this is to change to cylinder preference
                                          if ($('#PREFS_CYL').val() != mid.match(/^(\+|\-){1}/)[0]){
                                          //and that is what they are doing here
                                          pref = mid.match(/^(\+|\-){1}/)[0];
                                          $('#PREFS_CYL').val(pref);
                                          }
                                          }
                                          submit_form($(this));
                                          });
                  
                  $('#WODADD1').blur(function() {
                                     var mid = $('#WODADD1').val();
                                     if (!mid.match(/\./)) {
                                     var front = mid.match(/(\d{0,2})(\d{2})/)[1];
                                     var back = mid.match(/(\d{0,2})(\d{2})/)[2];
                                     mid = front + "." + back;
                                     }
                                     if (!mid.match(/^(\+)/)) {
                                     mid = "+" + mid;
                                     }
                                     $('#WODADD1').val(mid);
                                     $('#WOSADD1').val(mid);
                                     submit_form($('#WOSADD1'));
                                     });
                  $('#WODADD2').blur(function() {
                                     var near = $('#WODADD2').val();
                                     if (!near.match(/\./)) {
                                     var front = near.match(/(\d{0,2})(\d{2})/)[1];
                                     var back = near.match(/(\d{0,2})(\d{2})/)[2];
                                     near = front + "." + back;
                                     }
                                     if (!near.match(/^(\+)/)) {
                                     near= "+" + near;
                                     }
                                     $('#WODADD2').val(near);
                                     $('#WOSADD2').val(near);
                                     submit_form($('#WOSADD2'));
                                     });
                  
                  $("#simplePrint").click(function() {
                                          printElem({
                                                    pageTitle: 'Spectacle_Rx.html',
                                                    printBodyOptions:
                                                    {
                                                    styleToAdd:'padding:10px;background-color:white;margin:10px;color:#000000 !important;'
                                                    },
                                                    leaveOpen: true,
                                                    printMode: 'popup',
                                                    overrideElementCSS: true,
                                                    overrideElementCSS: ['../../forms/eye_mag/style.css']
                                                    });
                                          });
                  $("#ChangeTitle").click(function() {
                                          printElem({  });
                                          });
                  $("#PopupandLeaveopen").click(function() {
                                                printElem({  printMode: 'popup' });
                                                });
                  $("#stripCSS").click(function() {
                                       printElem({ overrideElementCSS: true });
                                       });
                  $("#externalCSS").click(function() {
                                          printElem({ overrideElementCSS: ['../../forms/eye_mag/style.css'] });
                                          });
                  $("input,textarea,text").focus(function(){
                                                 $(this).css("background-color","#ffff99");
                                                 });
                  
                  $("input,textarea,text,checkbox").change(function(){
                                                           $(this).css("background-color","#F0F8FF");
                                                           submit_form($(this));
                                                           });
                  
                  $("body").on("click","[name$='_text_view']" , function() {
                               var header = this.id.match(/(.*)_text_view$/)[1];
                               $("#"+header+"_text_list").toggleClass('wide_textarea');
                               $("#"+header+"_text_list").toggleClass('narrow_textarea');
                               $(this).toggleClass('fa-plus-square-o');
                               $(this).toggleClass('fa-minus-square-o');
                               if (header != /PRIOR/) {
                               var imagine = $("#PREFS_"+header+"_VIEW").val();
                               imagine ^= true;
                               $("#PREFS_"+header+"_VIEW").val(imagine);
                               update_PREFS();
                               }
                               });
                  
                  $("body").on("change", "select", function(e){
                               var new_section = this.name.match(/PRIOR_(.*)/);
                               var newValue = this.value;
                               $("#PRIORS_"+ new_section[1] +"_left_text").show();
                               $("#DRAWS_" + new_section[1] + "_right").hide();
                               $("#QP_" + new_section[1]).hide();
                               
                               // alert("id_to_show ="+newValue);
                               //now go get the prior page via ajax
                               var url = "../../forms/eye_mag/save.php?mode=retrieve";
                               if (new_section[1] =="ALL") {
                               show_PRIORS();
                               getSection("ALL");
                               getSection("EXT");
                               getSection("ANTSEG");
                               getSection("RETINA");
                               getSection("NEURO");
                               } else {
                               getSection(new_section[1]);
                               }
                               
                               function getSection(section) {
                               //  $("#PRIORS_"+ section +"_left_text").removeClass('nodisplay');
                               //    $("#" + section + "_right").addClass('nodisplay');
                               var formData = {
                               'PRIORS_query'          : "1",
                               'zone'                  : section,
                               'id_to_show'            : newValue,
                               'pid'                   : $('#pid').val(),
                               'orig_id'               : $('#form_id').val()
                               }
                               $.ajax({
                                      type 		: 'POST',
                                      url       : url,
                                      data 		: formData,
                                      success   : function(result) {
                                      $("#PRIORS_" + section + "_left_text").html(result);
                                      }
                                      });
                               }
                               });
                  $("body").on("click","[id^='Close_PRIORS_']", function() {
                               var new_section = this.id.match(/Close_PRIORS_(.*)$/)[1];
                               //   alert(new_section);
                               $("#PRIORS_"+ new_section +"_left_text").hide();
                               $("#QP_" + new_section).show();
                               });
                  $("#pupils").mouseover(function() {
                                         $("#pupils").toggleClass('buttonRefraction_selected').toggleClass('underline');
                                         });
                  
                  $("#pupils").mouseout(function() {
                                        $("#pupils").toggleClass("red");
                                        });
                  $("#pupils").click(function(){
                                     $("#dim_pupils_panel").toggleClass('nodisplay');
                                     });
                  $("#vision_tab").mouseover(function() {
                                             $("#vision_tab").toggleClass('buttonRefraction_selected').toggleClass('underline');
                                             });
                  $("#vision_tab").mouseout(function() {
                                            $("#vision_tab").toggleClass('buttonRefraction_selected').toggleClass('underline');
                                            });
                  $("#vision_tab").click(function(){
                                         $("#LayerVision2").toggle();
                                         ($("#PREFS_VA").val() =='1') ? ($("#PREFS_VA").val('0')) : $("#PREFS_VA").val('1');
                                         });
                  //set wearing to single vision or bifocal? Bifocal
                  $(".WNEAR").show();
                  $("#WNEARODAXIS").hide();
                  $("#WNEARODCYL").hide();
                  $("#WNEARODPRISM").hide();
                  $("#WNEAROSAXIS").hide();
                  $("#WNEAROSCYL").hide();
                  $("#WNEAROSPRISM").hide();
                  $("[name=RX]").val(["1"]);
                  $("#SingleVision_span").click(function(){
                                                $(".WNEAR").hide();
                                                $(".WSPACER").show();
                                                $("[name=RX]").val(["0"]);
                                                });
                  $("#Bifocal_span").click(function(){
                                           $(".WSPACER").hide();
                                           $(".WNEAR").show();
                                           $(".WMid").addClass('nodisplay');
                                           $(".WHIDECYL").removeClass('nodisplay');
                                           $("[name=RX]").val(["1"]);
                                           $("#WNEARODAXIS").hide();
                                           $("#WNEARODCYL").hide();
                                           $("#WNEARODPRISM").hide();
                                           $("#WNEAROSAXIS").hide();
                                           $("#WNEAROSCYL").hide();
                                           $("#WNEAROSPRISM").hide();
                                           });
                  $("#Trifocal_span").click(function(){
                                            $(".WSPACER").hide();
                                            $(".WNEAR").show();
                                            $(".WMid").removeClass('nodisplay');
                                            $(".WHIDECYL").addClass('nodisplay');
                                            $("[name=RX]").val(["2"]);
                                            $("#WNEARODAXIS").hide();
                                            $("#WNEARODCYL").hide();
                                            $("#WNEARODPRISM").hide();
                                            $("#WNEAROSAXIS").hide();
                                            $("#WNEAROSCYL").hide();
                                            $("#WNEAROSPRISM").hide();
                                            });
                  $("#Progressive_span").click(function(){
                                               $(".WSPACER").hide();
                                               $(".WNEAR").show();
                                               $(".WMid").addClass('nodisplay');
                                               $(".WHIDECYL").removeClass('nodisplay');
                                               $("[name=RX]").val(["3"]);
                                               $("#WNEARODAXIS").hide();
                                               $("#WNEARODCYL").hide();
                                               $("#WNEARODPRISM").hide();
                                               $("#WNEAROSAXIS").hide();
                                               $("#WNEAROSCYL").hide();
                                               $("#WNEAROSPRISM").hide();
                                               });
                  $("#Amsler-Normal").change(function() {
                                             if ($(this).is(':checked')) {
                                             var number1 = document.getElementById("AmslerOD").src.match(/(Amsler_\d)/)[1];
                                             document.getElementById("AmslerOD").src = document.getElementById("AmslerOD").src.replace(number1,"Amsler_0");
                                             var number2 = document.getElementById("AmslerOS").src.match(/(Amsler_\d)/)[1];
                                             document.getElementById("AmslerOS").src = document.getElementById("AmslerOS").src.replace(number2,"Amsler_0");
                                             $("#AMSLEROD").val("0");
                                             $("#AMSLEROS").val("0");
                                             $("#AmslerODvalue").text("0");
                                             $("#AmslerOSvalue").text("0");
                                             submit_form("eye_mag");
                                             return;
                                             }
                                             });
                  $("[name^='EXAM']").mouseover(function(){
                                                $(this).toggleClass("borderShadow2");
                                                });
                  $("[name^='EXAM']").mouseout(function(){
                                               $(this).toggleClass("borderShadow2");
                                               });
                  $("#AmslerOD, #AmslerOS").click(function() {
                                                  var number1 = this.src.match(/Amsler_(\d)/)[1];
                                                  var number2 = +number1 +1;
                                                  this.src = this.src.replace('Amsler_'+number1,'Amsler_'+number2);
                                                  this.src = this.src.replace('Amsler_6','Amsler_0');
                                                  $("#Amsler-Normal").removeAttr('checked');
                                                  var number3 = this.src.match(/Amsler_(\d)/)[1];
                                                  this.html =  number3;
                                                  if (number3 =="6") {
                                                  number3 = "0";
                                                  }
                                                  if ($(this).attr("id")=="AmslerOD") {
                                                  $("#AmslerODvalue").text(number3);
                                                  $('#AMSLEROD').val(number3);
                                                  } else {
                                                  $('#AMSLEROS').val(number3);
                                                  $("#AmslerOSvalue").text(number3);
                                                  }
                                                  var title = "#"+$(this).attr("id")+"_tag";
                                                  });
                  
                  $("#AmslerOD, #AmslerOS").mouseout(function() {
                                                     submit_form("eye_mag");
                                                     });
                  $("[name^='ODVF'],[name^='OSVF']").click(function() {
                                                           if ($(this).is(':checked') == true) {
                                                           $("#FieldsNormal").prop('checked', false);
                                                           $(this).val('1');
                                                           }else{
                                                           $(this).val('0');
                                                           $(this).prop('checked', false);
                                                           }
                                                           submit_form("eye_mag");
                                                           });
                  $("#FieldsNormal").click(function() {
                                           if ($(this).is(':checked')) {
                                           $("#ODVF1").removeAttr('checked');
                                           $("#ODVF2").removeAttr('checked');
                                           $("#ODVF3").removeAttr('checked');
                                           $("#ODVF4").removeAttr('checked');
                                           $("#OSVF1").removeAttr('checked');
                                           $("#OSVF2").removeAttr('checked');
                                           $("#OSVF3").removeAttr('checked');
                                           $("#OSVF4").removeAttr('checked');
                                           }
                                           });
                  $("[id^='EXT_prefix']").change(function() {
                                                 var newValue =$('#EXT_prefix').val();
                                                 newValue = newValue.replace('+', '');
                                                 if (newValue =="off") {$(this).val('');}
                                                 $("[name^='EXT_prefix_']").removeClass('eye_button_selected');
                                                 $("#EXT_prefix_"+ newValue).addClass("eye_button_selected");
                                                 });
                  $("#ANTSEG_prefix").change(function() {
                                             var newValue = $(this).val().replace('+', '');
                                             if ($(this).value =="off") {$(this).val('');}
                                             $("[name^='ANTSEG_prefix_']").removeClass('eye_button_selected');
                                             $("#ANTSEG_prefix_"+ newValue).addClass("eye_button_selected");
                                             });
                  $("#RETINA_prefix").change(function() {
                                             var newValue = $("#RETINA_prefix").val().replace('+', '');
                                             if ($(this).value =="off") {$(this).val('');}
                                             $("[name^='RETINA_prefix_']").removeClass('eye_button_selected');
                                             $("#RETINA_prefix_"+ newValue).addClass("eye_button_selected");
                                             });
                  $("#NEURO_prefix").change(function() {
                                            var newValue = $("#NEURO_prefix").val().replace('+', '');
                                            if ($(this).value =="off") {$(this).val('');}
                                            $("[name^='NEURO_prefix_']").removeClass('eye_button_selected');
                                            $("#NEURO_prefix_"+ newValue).addClass("eye_button_selected");
                                            });
                  $("AntSegSpan,#AntSegOD,#AntSegOU,#AntSegOS,#EXTOD,#EXTOU,#EXTOS,#RETINAOD,#RETINAOU,#RETINAOS").mouseover(function() {
                                                                                                                             $(this).toggleClass('button_over');
                                                                                                                             
                                                                                                                             });
                  $("AntSegSpan,#AntSegOD,#AntSegOU,#AntSegOS,#EXTOD,#EXTOU,#EXTOS,#RETINAOD,#RETINAOU,#RETINAOS").mouseout(function() {
                                                                                                                            $(this).toggleClass('button_over');
                                                                                                                            });
                  
                  $("AntSegSpan,#AntSegOD,#AntSegOU,#AntSegOS,#EXTOD,#EXTOU,#EXTOS,#RETINAOD,#RETINAOU,#RETINAOS").click(function() {
                                                                                                                         var section = this.id.match(/(.*)O.$/)[1];
                                                                                                                         var tabOU = "#"+section +"OU";
                                                                                                                         var tabOS = "#"+section +"OS";
                                                                                                                         var tabOD = "#"+section +"OD";
                                                                                                                         $(tabOU).removeClass('button_selected');
                                                                                                                         $(tabOD).removeClass('button_selected');
                                                                                                                         $(tabOS).removeClass('button_selected');
                                                                                                                         $(this).toggleClass('button_selected');
                                                                                                                         });
                  $("#LayerVision, #LayerTension, #LayerMotility, #LayerAmsler, #LayerFields, #LayerPupils,#dim_pupils_panel").mouseover(function(){
                                                                                                                                         $(this).toggleClass("borderShadow2");
                                                                                                                                         });
                  $("#LayerVision, #LayerTension, #LayerMotility, #LayerAmsler, #LayerFields, #LayerPupils,#dim_pupils_panel").mouseout(function(){
                                                                                                                                        $(this).toggleClass("borderShadow2");
                                                                                                                                        });
                  $("[id^=LayerVision_]").mouseover(function(){
                                                    $(this).toggleClass("borderShadow2");
                                                    });
                  $("[id^=LayerVision_]").mouseout(function(){
                                                   $(this).toggleClass("borderShadow2");
                                                   });
                  $("#LayerVision_W_lightswitch, #LayerVision_CR_lightswitch,#LayerVision_MR_lightswitch,#LayerVision_ADDITIONAL_lightswitch,#LayerVision_CTL_lightswitch").mouseover(function() {
                                                                                                                                                                                      $(this).addClass('buttonRefraction_selected');
                                                                                                                                                                                      });
                  $("#LayerVision_W_lightswitch, #LayerVision_CR_lightswitch,#LayerVision_MR_lightswitch,#LayerVision_ADDITIONAL_lightswitch,#LayerVision_CTL_lightswitch").mouseout(function() {
                                                                                                                                                                                     var section2 = this.id.match(/(.*)_(.*)_lightswitch$/)[2];
                                                                                                                                                                                     var elem = document.getElementById("PREFS_"+section2);
                                                                                                                                                                                     
                                                                                                                                                                                     if (elem.value != "1") {                                                                $(this).removeClass('buttonRefraction_selected');
                                                                                                                                                                                     } else {
                                                                                                                                                                                     $(this).addClass('buttonRefraction_selected');
                                                                                                                                                                                     }                                                                });
                  
                  $("#LayerVision_W_lightswitch, #LayerVision_CR_lightswitch,#LayerVision_MR_lightswitch,#LayerVision_ADDITIONAL_lightswitch,#LayerVision_CTL_lightswitch").click(function() {
                                                                                                                                                                                  var section = "#"+this.id.match(/(.*)_lightswitch$/)[1];
                                                                                                                                                                                  var section2 = this.id.match(/(.*)_(.*)_lightswitch$/)[2];
                                                                                                                                                                                  var elem = document.getElementById("PREFS_"+section2);
                                                                                                                                                                                  
                                                                                                                                                                                  if ($("#PREFS_VA").val() !='1') {
                                                                                                                                                                                  $("#PREFS_VA").val('1');
                                                                                                                                                                                  $("#LayerVision2").show();
                                                                                                                                                                                  elem.value="1";
                                                                                                                                                                                  $(section).removeClass('nodisplay');
                                                                                                                                                                                  if (section2 =="ADDITIONAL") {
                                                                                                                                                                                  $("#LayerVision_ADDITIONAL_VISION").removeClass('nodisplay');
                                                                                                                                                                                  }
                                                                                                                                                                                  $(this).addClass("buttonRefraction_selected");
                                                                                                                                                                                  } else {
                                                                                                                                                                                  if (elem.value == "0") {
                                                                                                                                                                                  elem.value='1';
                                                                                                                                                                                  if (section2 =="ADDITIONAL") {
                                                                                                                                                                                  $("#LayerVision_ADDITIONAL_VISION").removeClass('nodisplay');
                                                                                                                                                                                  }
                                                                                                                                                                                  $(section).removeClass('nodisplay');
                                                                                                                                                                                  $(this).addClass("buttonRefraction_selected");
                                                                                                                                                                                  } else {
                                                                                                                                                                                  elem.value='0';
                                                                                                                                                                                  $(section).addClass('nodisplay');
                                                                                                                                                                                  if (section2 =="ADDITIONAL") {
                                                                                                                                                                                  $("#LayerVision_ADDITIONAL_VISION").addClass('nodisplay');
                                                                                                                                                                                  }
                                                                                                                                                                                  $(this).removeClass("buttonRefraction_selected");
                                                                                                                                                                                  }
                                                                                                                                                                                  }
                                                                                                                                                                                  update_PREFS();                                                                                                                                                       });
                  
                  
                  //useful to make two VA fields stay in sync
                  
                  $("input[name$='VA']").blur(function() {
                                              var hereValue = $(this).val();
                                              var newValue = $(this).attr('name').replace('VA', 'VA_copy');
                                              $("#" + newValue).val(hereValue);
                                              $("#" + newValue + "_brd").val(hereValue);
                                              });
                  $("input[name$='_copy']").blur(function() {
                                                 var hereValue = $(this).val();
                                                 var newValue = $(this).attr('name').replace('VA_copy', 'VA');
                                                 $("#" + newValue).val(hereValue);
                                                 $("#" + newValue + "_copy_brd").val(hereValue);
                                                 submit_form("eye_mag");
                                                 });
                  $("input[name$='_copy_brd']").change(function() {
                                                       var hereValue = $(this).val();
                                                       var newValue = $(this).attr('name').replace('VA_copy_brd', 'VA');
                                                       $("#" + newValue).val(hereValue);
                                                       $("#" + newValue + "_copy").val(hereValue);
                                                       submit_form("eye_mag");
                                                       });
                  $("[name^='more_']").mouseover(function() {
                                                 $(this).toggleClass('buttonRefraction_selected').toggleClass('underline');
                                                 });
                  $("[name^='more_']").mouseout(function() {
                                                $(this).toggleClass('buttonRefraction_selected').toggleClass('underline');
                                                });
                  $("[name^='more_']").click(function() {
                                             $("#Visions_A").toggleClass('nodisplay');
                                             $("#Visions_B").toggleClass('nodisplay');
                                             });
                  $("#EXT_defaults").click(function() {
                                           $('#RUL').val('normal lids and lashes').css("background-color","beige");
                                           $('#LUL').val('normal lids and lashes').css("background-color","beige");
                                           $('#RLL').val('good tone').css("background-color","beige");
                                           $('#LLL').val('good tone').css("background-color","beige");
                                           $('#RBROW').val('no brow ptosis').css("background-color","beige");
                                           $('#LBROW').val('no brow ptosis').css("background-color","beige");
                                           $('#RMCT').val('no masses').css("background-color","beige");
                                           $('#RADNEXA').val('normal lacrimal gland and orbit').css("background-color","beige");
                                           $('#LADNEXA').val('normal lacrimal gland and orbit').css("background-color","beige");
                                           $('#LMCT').val('no masses').css("background-color","beige");
                                           $('#RMRD').val('+3').css("background-color","beige");
                                           $('#LMRD').val('+3').css("background-color","beige");
                                           $('#RLF').val('17').css("background-color","beige");
                                           $('#LLF').val('17').css("background-color","beige");
                                           submit_form("eye_mag");
                                           });
                  
                  $("#ANTSEG_defaults").click(function() {
                                              $('#ODCONJ').val('quiet').css("background-color","beige");
                                              $('#OSCONJ').val('quiet').css("background-color","beige");
                                              $('#ODCORNEA').val('clear').css("background-color","beige");
                                              $('#OSCORNEA').val('clear').css("background-color","beige");
                                              $('#ODAC').val('deep and quiet').css("background-color","beige");
                                              $('#OSAC').val('deep and quiet').css("background-color","beige");
                                              $('#ODLENS').val('clear').css("background-color","beige");
                                              $('#OSLENS').val('clear').css("background-color","beige");
                                              $('#ODIRIS').val('round').css("background-color","beige");
                                              $('#OSIRIS').val('round').css("background-color","beige");
                                              submit_form("eye_mag");
                                              });
                  $("#RETINA_defaults").click(function() {
                                              $('#ODDISC').val('pink').css("background-color","beige");
                                              $('#OSDISC').val('pink').css("background-color","beige");
                                              $('#ODCUP').val('0.3').css("background-color","beige");
                                              $('#OSCUP').val('0.3').css("background-color","beige");
                                              $('#ODMACULA').val('flat').css("background-color","beige");
                                              $('#OSMACULA').val('flat').css("background-color","beige");
                                              $('#ODVESSELS').val('2:3').css("background-color","beige");
                                              $('#OSVESSELS').val('2:3').css("background-color","beige");
                                              $('#ODPERIPH').val('flat, no tears, holes or RD').css("background-color","beige");
                                              $('#OSPERIPH').val('flat, no tears, holes or RD').css("background-color","beige");
                                              submit_form("eye_mag");
                                              });
                  $("#NEURO_defaults").click(function() {
                                             $('#ODPUPILSIZE1').val('3.0').css("background-color","beige");
                                             $('#ODPUPILSIZE2').val('2.0').css("background-color","beige");
                                             $('#ODPUPILREACTIVITY').val('+2').css("background-color","beige");
                                             $('#ODAPD').val('0').css("background-color","beige");
                                             $('#OSPUPILSIZE1').val('3.0').css("background-color","beige");
                                             $('#OSPUPILSIZE2').val('2.0').css("background-color","beige");
                                             $('#OSPUPILREACTIVITY').val('+2').css("background-color","beige");
                                             $('#OSAPD').val('0').css("background-color","beige");
                                             $('#ODVFCONFRONTATION1').val('0').css("background-color","beige");
                                             $('#ODVFCONFRONTATION2').val('0').css("background-color","beige");
                                             $('#ODVFCONFRONTATION3').val('0').css("background-color","beige");
                                             $('#ODVFCONFRONTATION4').val('0').css("background-color","beige");
                                             $('#ODVFCONFRONTATION5').val('0').css("background-color","beige");
                                             $('#OSVFCONFRONTATION1').val('0').css("background-color","beige");
                                             $('#OSVFCONFRONTATION2').val('0').css("background-color","beige");
                                             $('#OSVFCONFRONTATION3').val('0').css("background-color","beige");
                                             $('#OSVFCONFRONTATION4').val('0').css("background-color","beige");
                                             $('#OSVFCONFRONTATION5').val('0').css("background-color","beige");
                                             submit_form("eye_mag");
                                             });
                  
                  $("#EXAM_defaults").click(function() {
                                            $('#RUL').val('normal lids and lashes').css("background-color","beige");
                                            $('#LUL').val('normal lids and lashes').css("background-color","beige");
                                            $('#RLL').val('good tone').css("background-color","beige");
                                            $('#LLL').val('good tone').css("background-color","beige");
                                            $('#RBROW').val('no brow ptosis').css("background-color","beige");
                                            $('#LBROW').val('no brow ptosis').css("background-color","beige");
                                            $('#RMCT').val('no masses').css("background-color","beige");
                                            $('#LMCT').val('no masses').css("background-color","beige");
                                            $('#RADNEXA').val('normal lacrimal gland and orbit').css("background-color","beige");
                                            $('#LADNEXA').val('normal lacrimal gland and orbit').css("background-color","beige");
                                            $('#RMRD').val('+3').css("background-color","beige");
                                            $('#LMRD').val('+3').css("background-color","beige");
                                            $('#RLF').val('17').css("background-color","beige");
                                            $('#LLF').val('17').css("background-color","beige");
                                            $('#OSCONJ').val('quiet').css("background-color","beige");
                                            $('#ODCONJ').val('quiet').css("background-color","beige");
                                            $('#ODCORNEA').val('clear').css("background-color","beige");
                                            $('#OSCORNEA').val('clear').css("background-color","beige");
                                            $('#ODAC').val('deep and quiet, -F/C').css("background-color","beige");
                                            $('#OSAC').val('deep and quiet, -F/C').css("background-color","beige");
                                            $('#ODLENS').val('clear').css("background-color","beige");
                                            $('#OSLENS').val('clear').css("background-color","beige");
                                            $('#ODIRIS').val('round').css("background-color","beige");
                                            $('#OSIRIS').val('round').css("background-color","beige");
                                            $('#ODPUPILSIZE1').val('3.0').css("background-color","beige");
                                            $('#ODPUPILSIZE2').val('2.0').css("background-color","beige");
                                            $('#ODPUPILREACTIVITY').val('+2').css("background-color","beige");
                                            $('#ODAPD').val('0').css("background-color","beige");
                                            $('#OSPUPILSIZE1').val('3.0').css("background-color","beige");
                                            $('#OSPUPILSIZE2').val('2.0').css("background-color","beige");
                                            $('#OSPUPILREACTIVITY').val('+2').css("background-color","beige");
                                            $('#OSAPD').val('0').css("background-color","beige");
                                            $('#ODVFCONFRONTATION1').val('0').css("background-color","beige");
                                            $('#ODVFCONFRONTATION2').val('0').css("background-color","beige");
                                            $('#ODVFCONFRONTATION3').val('0').css("background-color","beige");
                                            $('#ODVFCONFRONTATION4').val('0').css("background-color","beige");
                                            $('#ODVFCONFRONTATION5').val('0').css("background-color","beige");
                                            $('#OSVFCONFRONTATION1').val('0').css("background-color","beige");
                                            $('#OSVFCONFRONTATION2').val('0').css("background-color","beige");
                                            $('#OSVFCONFRONTATION3').val('0').css("background-color","beige");
                                            $('#OSVFCONFRONTATION4').val('0').css("background-color","beige");
                                            $('#OSVFCONFRONTATION5').val('0').css("background-color","beige");
                                            $('#ODDISC').val('pink').css("background-color","beige");
                                            $('#OSDISC').val('pink').css("background-color","beige");
                                            $('#ODCUP').val('0.3').css("background-color","beige");
                                            $('#OSCUP').val('0.3').css("background-color","beige");
                                            $('#ODMACULA').val('flat').css("background-color","beige");
                                            $('#OSMACULA').val('flat').css("background-color","beige");
                                            $('#ODVESSELS').val('2:3').css("background-color","beige");
                                            $('#OSVESSELS').val('2:3').css("background-color","beige");
                                            $('#ODPERIPH').val('flat, no tears, holes or RD').css("background-color","beige");
                                            $('#OSPERIPH').val('flat, no tears, holes or RD').css("background-color","beige");
                                            submit_form("eye_mag");
                                            });
                  
                  $("#MOTILITYNORMAL").click(function() {
                                             $("#MOTILITY_RS").val('0');
                                             $("#MOTILITY_RI").val('0');
                                             $("#MOTILITY_RR").val('0');
                                             $("#MOTILITY_RL").val('0');
                                             $("#MOTILITY_LS").val('0');
                                             $("#MOTILITY_LI").val('0');
                                             $("#MOTILITY_LR").val('0');
                                             $("#MOTILITY_LL").val('0');
                                             for (index = '0'; index < 5; ++index) {
                                             $("#MOTILITY_RS_"+index).html('');
                                             $("#MOTILITY_RI_"+index).html('');
                                             $("#MOTILITY_RR_"+index).html('');
                                             $("#MOTILITY_RL_"+index).html('');
                                             $("#MOTILITY_LS_"+index).html('');
                                             $("#MOTILITY_LI_"+index).html('');
                                             $("#MOTILITY_LR_"+index).html('');
                                             $("#MOTILITY_LL_"+index).html('');
                                             }
                                             });
                  
                  $("[name^='MOTILITY_']").click(function()  {
                                                 $("#MOTILITYNORMAL").removeAttr('checked');
                                                 
                                                 var zone = this.id.match(/(MOTILITY_..)_(.)/);
                                                 var valued = isNaN($("#"+zone[1]).val());
                                                 
                                                 if (valued != true && $("#"+zone[1]).val() <'4') {
                                                 valued=$("#"+zone[1]).val();
                                                 valued++;
                                                 } else {
                                                 valued = '0';
                                                 $("#"+zone[1]).val('0');
                                                 }
                                                 
                                                 $("#"+zone[1]).val(valued);
                                                 var section = this.id.match(/MOTILITY_(.)(.)_/);
                                                 var section2 = section[2];
                                                 var Eye = section[1];
                                                 var SupInf = section2.search(/S|I/);
                                                 var RorLside   = section2.search(/R|L/);
                                                 var index   = '0';
                                                 
                                                 if (RorLside =='0') {
                                                 var hash_tag = '<i class="fa fa-minus rotate-left">';
                                                 } else {
                                                 var hash_tag = '<i class="fa fa-minus">';
                                                 }
                                                 for (index = '0'; index < 5; ++index) {
                                                 $("#"+zone[1]+"_"+index).html('');
                                                 }
                                                 if (valued > '0') {
                                                 for (index =1; index < (valued+1); ++index) {
                                                 $("#"+zone[1]+"_"+index).html(hash_tag);
                                                 }
                                                 }
                                                 submit_form();
                                                 });
                  
                  $("[name^='Close_']").click(function()  {
                                              var section = this.id.match(/Close_(.*)$/)[1];
                                              if (section =="ACTMAIN") {
                                              $("#ACTTRIGGER").trigger( "click" );
                                              } else {
                                              $("#LayerVision_"+section+"_lightswitch").click();
                                              }
                                              });
                  
                  $("#MOTILITYORMAL").click(function() {
                                            //reset all motility measurements to zero if checked
                                            //if not, then leave alone...
                                            });
                  $("#EXAM_DRAW,[id^='BUTTON_DRAW_']").click(function() {
                                        if ($("#PREFS_CLINICAL").value !='0') {
                                        show_right();
                                        $("#PREFS_CLINICAL").val('0');
                                        update_PREFS();
                                        }
                                        if ($("#PREFS_EXAM").value != 'DRAW') {
                                        $("#PREFS_EXAM").val('DRAW');
                                        show_DRAW();
                                        $("#EXAM_QP").removeClass('button_selected');
                                        $("#EXAM_DRAW").addClass('button_selected');
                                        $("#EXAM_CLINICAL").removeClass('button_selected');
                                        update_PREFS();
                                        }
                                        });
                  $("#EXAM_QP").click(function() {
                                      if ($("#PREFS_CLINICAL").value !='0') {
                                      $("#PREFS_CLINICAL").val('0');
                                      update_PREFS();
                                      }
                                      if ($("#PREFS_EXAM").value != 'QP') {
                                      show_QP();
                                      $("#PREFS_EXAM").val('QP');
                                      $("#EXAM_QP").addClass('button_selected');
                                      $("#EXAM_DRAW").removeClass('button_selected');
                                      $("#EXAM_CLINICAL").removeClass('button_selected');
                                      update_PREFS();
                                      }
                                      });
                  
                  $("#EXAM_CLINICAL,[id^='BUTTON_TEXT_']").click(function() {
                                            if ($("#PREFS_CLINICAL").val() !='1') {
                                            //we want to show text_only which are found on left half
                                            $("#PREFS_CLINICAL").val('1');
                                            $("#PREFS_EXAM").val('TEXT');
                                            show_TEXT();
                                            // also hide QP, DRAWs, and PRIORS
                                            hide_PRIORS();
                                            hide_DRAW();
                                            hide_QP();
                                            update_PREFS();
                                            }
                                            $("#EXAM_DRAW").removeClass('button_selected');
                                            $("#EXAM_QP").removeClass('button_selected');
                                            $("#EXAM_CLINICAL").addClass('button_selected');
                                            });
                  $("#EXAM_CLINICAL").addClass('button_selected');
                  if ($("#PREFS_CLINICAL").val() !='1') {
                  var actionQ = "#EXAM_"+$("#PREFS_EXAM").val();
                  // alert(actionQ);
                  $(actionQ).trigger('click');
                  //$("#EXAM_QP").val("1").trigger('click');
                  } else {
                  $("#EXAM_CLINICAL").addClass('button_selected');
                  }
                  if ($("#ANTSEG_prefix").val() > '') {
                  $("#ANTSEG_prefix_"+$("#ANTSEG_prefix").val()).addClass('button_selected');
                  } else {
                  $("#ANTSEG_prefix").val('off').trigger('change');
                  }
                  
                  $("[name^='ACT_tab_']").click(function()  {
                                                var section = this.id.match(/ACT_tab_(.*)/)[1];
                                                $("[name^='ACT_']").addClass('nodisplay');
                                                $("[name^='ACT_tab_']").removeClass('nodisplay').removeClass('ACT_selected').addClass('ACT_deselected');
                                                $("#ACT_tab_" + section).addClass('ACT_selected').removeClass('ACT_deselected');
                                                $("#ACT_" + section).removeClass('nodisplay');
                                                $("#PREFS_ACT_SHOW").val(section);
                                                update_PREFS();
                                                });
                  $("#ACTTRIGGER").mouseover(function() {
                                             $("#ACTTRIGGER").toggleClass('buttonRefraction_selected').toggleClass('underline');
                                             
                                             });
                  $("#ACTTRIGGER").mouseout(function() {
                                            $("#ACTTRIGGER").toggleClass('buttonRefraction_selected').toggleClass('underline');
                                            });
                  if ($("#PREFS_ACT_VIEW").val() == '1') {
                    $("#ACTMAIN").toggleClass('nodisplay'); //.toggleClass('fullscreen');
                    $("#NPCNPA").toggleClass('nodisplay');
                    $("#ACTNORMAL_CHECK").toggleClass('nodisplay');
                    $("#ACTTRIGGER").toggleClass('underline');
                  var show = $("#PREFS_ACT_SHOW").val();
                  //alert($("#PREFS_ACT_SHOW").val());
                  $("#ACT_tab_"+show).trigger('click');
                  }
                  $("#ACTTRIGGER").click(function() {
                                         $("#ACTMAIN").toggleClass('nodisplay'); //.toggleClass('fullscreen');
                                         $("#NPCNPA").toggleClass('nodisplay');
                                         $("#ACTNORMAL_CHECK").toggleClass('nodisplay');
                                         $("#ACTTRIGGER").toggleClass('underline');
                                         if ($("#PREFS_ACT_VIEW").val()=='1') {
                                            $("#PREFS_ACT_VIEW").val('0');
                                         } else {
                                            $("#PREFS_ACT_VIEW").val('1');
                                         }
                                         var show = $("#PREFS_ACT_SHOW").val();
                                         $("#ACT_tab_"+show).trigger('click');
                                         update_PREFS();
                                         });
                  
                  
/* Now it is time to figure out how to blow-up each section for a tablet for example to fill the screen and look good */
                  $("[name^='MAX_']").click(function() {
                                            
                                            alert("This button will allow the user to enter a fullscreen mode useful for tablet operations.  It needs to be written yet but essentially it will present the data in a format specific to the device's screen size...");
                                            
                                            //let's add a class to make this frame fullscreen
                                            //var section = this.id.match(/MAX_(.*)/)[1];
                                            //$("#"+ section + "_left").toggleClass('fullscreen');
                                            
                                            //to show the prior visits on screen using the selector script scroller
                                            //click this and toggle class nodisplay for id=PRIORS_NEURO_sections and NEURO_left
                                            //  $("#PRIORS_NEURO_sections").toggleClass('nodisplay');
                                            //  $("#NEURO_left").toggleClass('nodisplay');
                                            //we have to get the data to put here!
                                            
                                            });
                  $("#NEURO_COLOR").click(function() {
                                          $("#ODCOLOR").val("11/11");
                                          $("#OSCOLOR").val("11/11");
                                          submit_form("eye_mag");
                                          });
                  
                  $("#NEURO_COINS").click(function() {
                                          $("#ODCOINS").val("1.00");
                                          //leave currency symbol out unless it is an openEMR defined option
                                          $("#OSCOINS").val("1.00");
                                          submit_form("eye_mag");
                                          });
                  
                  $("#NEURO_REDDESAT").click(function() {
                                             $("#ODREDDESAT").val("100");
                                             $("#OSREDDESAT").val("100");
                                             submit_form("eye_mag");
                                             });
                  $("[id^='Sketch_']").mouseout(function() {
                                                var zone = this.id.match(/Sketch_(.*)/)[1];
                                                var dataURL = this.toDataURL();
                                                $.ajax({
                                                       type: "POST",
                                                       url: "../../forms/eye_mag/save.php?canvas="+zone+"&id="+$("#id").val(),
                                                       data: {
                                                       imgBase64     : dataURL,
                                                       'zone'        : zone,
                                                       'visit_date'  : $("#visit_date").val(),
                                                       'encounter'   : $("#encounter").val()
                                                       },
                                                       success      : function(result) {
                                                       
                                                       $("#tellme").html(result);
                                                       }
                                                       }).done(function(o) {
                                                               //          console.log(result);
                                                               });
                                                });
                  
                  
                  
                  
                  $("#COPY_SECTION").change(function() {
                                            //  alert($("#COPY_SECTION").val());
                                            var start = $("#COPY_SECTION").val();
                                            var value = start.match(/(\w*)-(\w*)/);
                                            var zone = value[1];
                                            var copy_from = value[2];
                                            var data = {
                                            "action"      : "copy",
                                            'copy'        : zone,
                                            'zone'        : zone,
                                            'copy_to'     : $("#id").val(),
                                            'copy_from'   : copy_from,
                                            'pid'         : $("#pid").val()
                                            };
                                            data = $("#"+zone+"_left_text").serialize() + "&" + $.param(data);
                                            $.ajax({
                                                   type 	: 'POST',
                                                   dataType : 'json',
                                                   url      :  "../../forms/eye_mag/save.php?copy="+zone,
                                                   data 	: data,
                                                   success  : function(result) {
                                                    $.map(result, function(valhere, keyhere) {
                                                        if ($("#"+keyhere).val() != valhere) {  $("#"+keyhere).val(valhere).css("background-color","#CCF");}
                                                        if (keyhere.match(/MOTILITY_/)) { //copy forward ductions and versions visually
                                                            //make each blank, and rebuild them
                                                            $("[name='"+keyhere+"_1']").html('');
                                                            $("[name='"+keyhere+"_2']").html('');
                                                            $("[name='"+keyhere+"_3']").html('');
                                                            $("[name='"+keyhere+"_4']").html('');
                                                            if (keyhere.match(/(_RS|_LS|_RI|_LI)/)) {  //show a horizontal (minus) tag
                                                                hash_tag = '<i class="fa fa-minus"></i>';
                                                            } else { //show vertical tag
                                                                hash_tag = '<i class="fa fa-minus rotate-left"></i>';
                                                            }
                                                            for (index =1; index <= valhere; ++index) {
                                                                $("#"+keyhere+"_"+index).html(hash_tag);
                                                            }
                                                         }
                                                          });
                                                   }
                                                   }).done(function (){
                                                           submit_form("eye_mag");
                                                           });
                                            });
                  
                  
                 $("[id^='BUTTON_DRAW_']").click(function() {
                                                   var zone =this.id.match(/BUTTON_DRAW_(.*)$/)[1];
                                                 show_DRAW();
                                                });
                  
                  $("#construction").click(function() {
                                           $("[id^='CONSTRUCTION_']").toggleClass('nodisplay');
                                           });
                window.addEventListener("beforeunload", function () {
                                        $("#final").val('1');
                                        //submit_form("final");
                                        refreshme();
                                        //parent.frames['RBot'].location.reload();
                                        // alert("the url of the top is" + top.location.href + "\nand not the url of this one is " + window.location.href );
                                       });
                  $("[name$='_loading']").addClass('nodisplay');
                  $("[name$='_sections']").removeClass('nodisplay');
                  
                  });



