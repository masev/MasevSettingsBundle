<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
<link href="/extension/masev_settings/design/standard/stylesheets/xeditable.css" rel="stylesheet">

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.10/angular.min.js"></script>
<script src="/extension/masev_settings/design/standard/javascript/app.js"></script>
<script src="/extension/masev_settings/design/standard/javascript/xeditable.js"></script>

{literal}
<style type="text/css">
    #leftmenu {
        display: none !important;
    }

    #maincontent {
        margin-left: 25px !important;
    }

    #left-panels-separator {
        left: 0px !important;
    }

    .dropdown {
        display: inline;
    }

    div.tab-content {
        height: 100%;
    }

    #submitButton {
        margin-top:15px;
    }
</style>
<script>
    $(function () {
        $('[data-toggle="tooltip"]').tooltip()
    })
</script>
{/literal}

<div ng-app="masevSettings">
    <div ng-controller="SettingsController as settings">
        <div class="panel panel-default">
            <div class="panel-body">
                <form method="get">
                    {'Please select a site to access configuration'|i18n('masev_settings')}
                    <div class="dropdown">
                        <button class="btn btn-default dropdown-toggle" type="button" id="dropdownSiteMenu" data-toggle="dropdown" aria-expanded="true">
                            {'Site list'|i18n('masev_settings')}
                            <span class="caret"></span>
                        </button>
                        <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                            <li role="presentation" data-toggle="tooltip" data-placement="top" title="{'Default apply on all site except if a site has already a value defined'|i18n('masev_settings')}"><a role="menuitem" tabindex="-1" ng-click="generateTable('default');">Default</a></li>
                            {foreach ezini('SiteSettings', 'SiteList') as $site}
                            <li role="presentation"><a role="menuitem" tabindex="-1" ng-click="generateTable('{$site}');" >{$site}</a></li>
                            {/foreach}
                        </ul>
                    </div>
                </form>
            </div>
        </div>

        <div ng-show="settings.xhrCount >= 2" class="box-header"><div class="box-ml">
                <h1 class="context-title">{'Settings'|i18n('masev_settings')} {literal}{{ settings.site }}{/literal}
                </h1>
                <div class="header-mainline"></div>
            </div>
        </div>
        {literal}

        <div ng-hide="settings.xhrCount >= 2 || settings.xhrCount == -1" style="position: absolute;width: 100%;margin: 0;height: 50%; z-index: 9999; text-align: center;">
            <img style="margin-top: 50px;" src="/extension/masev_settings/design/standard/images/loading.gif" width="100px" />
        </div>
        <div role="tabpanel" ng-show="settings.xhrCount >= 2">
            <!-- Nav tabs -->
            <ul class="nav nav-tabs" role="tablist">
                <li ng-repeat="(level1, level2_sections) in settings.sections" role="presentation" class="dropdown" ng-class="{active: $index === 0}">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-expanded="false">
                        {{ level1 }} <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu" role="menu">
                        <li ng-repeat="(level2, value) in level2_sections" role="presentation"><a href="#tab_{{level1}}_{{level2}}" aria-controls="settings" role="tab" data-toggle="tab">{{ level2 }}</a></li>
                    </ul>
                </li>
            </ul>

            <!-- Tab panes -->
            <div class="tab-content">
                <div ng-repeat="(key, level2_section) in settings.level2_sections" role="tabpanel" ng-class="{active: $index === 0}" class="tab-pane" id="tab_{{level2_section.level1}}_{{level2_section.name}}">
                    <h2>{{ level2_section.name }} <small>{{ level2_section.level1 }}</small></h2>

                    <div ng-repeat="(key, item) in settings.data" class="form-group">
                        <label ng-show="item.schema.key.indexOf(level2_section.name) > -1 && item.schema.key.indexOf(level2_section.level1) > -1" for="{{ key }}">{{ item.schema.name }} :</label>
                        <span e-form="textBtnForm" ng-show="item.schema.key.indexOf(level2_section.name) > -1 && item.schema.key.indexOf(level2_section.level1) > -1" id="{$key}" editable-text="item.data" onbeforesave="updateSettings(item, $data)" >{{ item.data == "" ? "Empty value, example : "+item.schema.default : item.data }}</span>
                        <button ng-show="!textBtnForm.$visible && item.schema.key.indexOf(level2_section.name) > -1 && item.schema.key.indexOf(level2_section.level1) > -1" class="btn btn-default" ng-click="textBtnForm.$show()">
                            edit
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div style="margin-top: 15px;" ng-show="settings.editCount > 0" class="alert alert-warning" role="alert">
            Des changements ont été effectué ! <a ng-click="clearCache()">Vider le cache</a>
        </div>
    </div>
    {/literal}
</div>