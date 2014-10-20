<?php

$module = $Params['Module'];
$http = eZHTTPTool::instance();
$tpl = eZTemplate::factory();
$container = ezpKernel::instance()->getServiceContainer();

$site = ($http->hasGetVariable('site') ? $http->getVariable('site') : 'default');
$settingsModel = $container->get("masev_settings.model.settings");

if ($http->hasPostVariable('SaveConfigButton')) {
    foreach ($http->postVariable('config') as $key => $value) {
        if ($value != "") {
            $settingsModel->__set($key, $value);
        } else {
            $settingsModel->__set($key, null);
        }
    }
    $settingsModel->save($site);
}


$tpl->setVariable("schema", $container->getParameter("masev_settings.schema"));
$tpl->setVariable("data", $settingsModel->getDataAsArray($site));

$Result = array();
$Result['content'] = $tpl->fetch( "design:configuration/index.tpl" );
$Result['left_menu'] = "design:configuration/backoffice_left_menu.tpl";
$Result['path'] = array( array( 'url' => false,
                                'text' => 'Configuration' ),
                         array( 'url' => false,
                                'text' => 'index' )
);