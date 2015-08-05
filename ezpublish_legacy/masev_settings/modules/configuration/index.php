<?php

$module = $Params['Module'];
$http = eZHTTPTool::instance();
$tpl = eZTemplate::factory();
$tpl->setVariable("siteaccess", $GLOBALS['eZCurrentAccess']['name']);
$Result = array();
$Result['content'] = $tpl->fetch( "design:configuration/index.tpl" );
$Result['left_menu'] = "design:configuration/backoffice_left_menu.tpl";
$Result['path'] = array( array( 'url' => false,
                                'text' => 'Configuration' ),
                         array( 'url' => false,
                                'text' => 'index' )
);