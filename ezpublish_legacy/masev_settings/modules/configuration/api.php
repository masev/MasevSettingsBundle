<?php

$module = $Params['Module'];
$http = eZHTTPTool::instance();
$container = ezpKernel::instance()->getServiceContainer();

switch ($Params['function']) {
    case 'schema':
        header( 'Content-Type: application/json; charset=UTf-8' );
        echo json_encode($container->getParameter("masev_settings.schema"));

        break;

    case 'data':
        header( 'Content-Type: application/json; charset=UTf-8' );
        $site = $http->getVariable('site');
        echo json_encode($container->get("masev_settings.model.settings")->getDataAsArray($site));

        break;

    case 'sections':
        header( 'Content-Type: application/json; charset=UTf-8' );
        echo json_encode($container->get("masev_settings.model.settings")->getSections());

        break;

    case 'update':
        header( 'Content-Type: application/json; charset=UTf-8' );
        try {
            $settingsModel = $container->get("masev_settings.model.settings");
            $data = json_decode(file_get_contents('php://input'), true);

            $settingsModel->__set($data['item']['schema']['key'], urldecode($data['value']));
            $settingsModel->save($data['site']);

            echo json_encode(true);
        } catch (\Exception $e) {
            echo json_encode(false);
        }

        break;

    case 'clearCache':
        header( 'Content-Type: application/json; charset=UTf-8' );

        // Force container regeneration
        $kernel = $container->get('kernel');
        $injectionManager = $container->get('masev_settings.dependency_injection.container_injection_manager');
        $injectionManager->rebuild($kernel);
        $container->get( 'ezpublish.http_cache.purger' )->purge( array("*") );

        echo json_encode(true);

        break;
}

eZExecution::cleanExit();