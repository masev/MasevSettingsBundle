<?php
namespace Masev\SettingsBundle\Controller;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;

/**
 * Class ApiController
 */
class ApiController extends Controller
{
    public function schemaAction()
    {
        return new JsonResponse($this->container->getParameter("masev_settings.schema"));
    }

    public function dataAction(Request $request)
    {
        $site = $request->query->get("site");
        return new JsonResponse($this->container->get("masev_settings.model.settings")->getDataAsArray($site));
    }

    public function sectionsAction()
    {
        return new JsonResponse($this->container->get("masev_settings.model.settings")->getSections());
    }

    public function updateAction(Request $request)
    {
        try {
            $settingsModel = $this->get("masev_settings.model.settings");
            $data = json_decode($request->getContent(), true);

            $settingsModel->__set($data['item']['schema']['key'], $data['value']);
            $settingsModel->save($data['site']);
        } catch (\Exception $e) {
            return new JsonResponse(false);
        }

        return new JsonResponse(true);
    }
}