<?php

$Module = array( 'name' => 'Masev Settings' );

$ViewList = array();
$ViewList['index'] = array(
    'functions' => array( 'read' ),
    'default_navigation_part' => 'ezmasevsettingsnavigationpart',
    'ui_context' => 'administration',
    'script' => 'index.php');

$FunctionList = array();
$FunctionList['read'] = array();
?>
