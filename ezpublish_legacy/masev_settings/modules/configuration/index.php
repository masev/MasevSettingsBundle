<?php

$module = $Params['Module'];
$http = eZHTTPTool::instance();
$tpl = eZTemplate::factory();
$container = ezpKernel::instance()->getServiceContainer();

$tpl->setVariable("schema", $container->getParameter("masev_settings.schema"));
$tpl->setVariable("data", $container->get("masev_settings.model.settings")->getDataAsArray());

$Result = array();
$Result['content'] = $tpl->fetch( "design:configuration/index.tpl" );
$Result['left_menu'] = "design:configuration/backoffice_left_menu.tpl";
$Result['path'] = array( array( 'url' => false,
                                'text' => 'Configuration' ),
                         array( 'url' => false,
                                'text' => 'index' )
);