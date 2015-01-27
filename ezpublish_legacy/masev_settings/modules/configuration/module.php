<?php

$Module = array( 'name' => 'Masev Settings' );

$ViewList = array();
$ViewList['index'] = array(
    'functions' => array( 'read' ),
    'default_navigation_part' => 'ezmasevsettingsnavigationpart',
    'ui_context' => 'administration',
    'script' => 'index.php',
    'params' => array( 'api', 'function' ) );

$ViewList['api'] = array(
    'functions' => array( 'read' ),
    'default_navigation_part' => 'ezmasevsettingsnavigationpart',
    'ui_context' => 'administration',
    'script' => 'api.php',
    'params' => array( 'function' ) );

$FunctionList = array();
$FunctionList['read'] = array();
?>
