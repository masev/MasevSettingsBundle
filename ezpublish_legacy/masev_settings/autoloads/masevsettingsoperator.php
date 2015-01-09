<?php

/*!
  \class   TemplateMasevsettingsOperator templatemasevsettingsoperator.php
  \ingroup eZTemplateOperators
  \brief   Prend en charge l'opérateur de template masevsettings. En utilisant masevsettings vous pouvez...

  \version 1.0
  \date    vendredi 09 janvier 2015 15:50:22
  \author  Matthieu Sévère

  

  Exemple:
\code
{masevsettings('first',$input2)|wash}
\endcode
*/

/*
If you want to have autoloading of this operator you should create
a eztemplateautoload.php file and add the following code to it.
The autoload file must be placed somewhere specified in AutoloadPathList
under the group TemplateSettings in settings/site.ini

$eZTemplateOperatorArray = array();
$eZTemplateOperatorArray[] = array( 'script' => 'templatemasevsettingsoperator.php',
                                    'class' => 'TemplateMasevsettingsOperator',
                                    'operator_names' => array( 'masevsettings' ) );

If your template operator is in an extension, you need to add the following settings:

To extension/YOUREXTENSION/settings/site.ini.append:
---
[TemplateSettings]
ExtensionAutoloadPath[]=YOUREXTENSION
---

To extension/YOUREXTENSION/autoloads/eztemplateautoload.php:
----
$eZTemplateOperatorArray = array();
$eZTemplateOperatorArray[] = array( 'script' => 'extension/YOUEXTENSION/YOURPATH/templatemasevsettingsoperator.php',
                                    'class' => 'TemplateMasevsettingsOperator',
                                    'operator_names' => array( 'masevsettings' ) );
---

Create the files if they don't exist, and replace YOUREXTENSION and YOURPATH with the correct values.

*/


class MasevSettingsOperator
{
    /*!
      Constructeur, par défaut ne fait rien.
    */
    function __construct()
    {
    }

    /*!
     \return an array with the template operator name.
    */
    function operatorList()
    {
        return array( 'masevsettings' );
    }

    /*!
     \return true to tell the template engine that the parameter list exists per operator type,
             this is needed for operator classes that have multiple operators.
    */
    function namedParameterPerOperator()
    {
        return true;
    }

    /*!
     See eZTemplateOperator::namedParameterList
    */
    function namedParameterList()
    {
        return array( 'masevsettings' => array( 'first_param' => array( 'type' => 'string',
            'required' => false,
            'default' => 'default text' ),
            'second_param' => array( 'type' => 'integer',
                'required' => false,
                'default' => 0 ) ) );
    }


    /*!
     Exécute la fonction PHP correspondant à l'opérateur "cleanup" et modifie \a $operatorValue.
    */
    function modify( $tpl, $operatorName, $operatorParameters, $rootNamespace, $currentNamespace, &$operatorValue, $namedParameters, $placement )
    {
        $firstParam = $namedParameters['first_param'];
        $secondParam = $namedParameters['second_param'];
        switch ( $operatorName )
        {
            case 'masevsettings':
            {
                $container = ezpKernel::instance()->getServiceContainer();
                $configResolver = $container->get('ezpublish.config.resolver');
                $operatorValue = $configResolver->getParameter($firstParam, "masev_settings");
            } break;
        }
    }
}

?>