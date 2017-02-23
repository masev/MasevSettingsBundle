<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
<link href="/extension/masev_settings/design/standard/stylesheets/xeditable.css" rel="stylesheet">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.10/angular.min.js"></script>
<script src="/extension/masev_settings/design/standard/javascript/app.js"></script>
<script src="/extension/masev_settings/design/standard/javascript/xeditable.js"></script>
<script>
    var currentSiteAccess = "{$siteaccess}";
</script>

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

    .editable-browse .form-control {
        height: 100%;
    }

    a[ng-click]{
        cursor: pointer;
    }

    div.browser-widget {
        width: 300px !important;
        height: 250px !important;
        overflow: auto;
        position: relative;
        padding-bottom: 25px;
    }

    img.browse-loader {
        margin: 0 auto;
        display: block;
        padding-top: 107px;
    }

    div.bottom-bar {
        height: 25px;
        bottom: 0px;
        left: 0px;
        width: 100%;
        background-color: lightgrey;
        padding-left: 12px;
        padding-top: 3px;
    }

    div.top-bar {
        position: absolute;
        height: 25px;
        top: 0px;
        left: 0px;
        margin: 0px;
        width: 100%;
        background-color: lightgrey;
        padding-left: 12px;
        padding-top: 3px;
    }

    div.categorie {
        font-size: 16px;
        font-weight: bold;
        margin-bottom: 6px;
        display: block;
        margin-left: 15px;
        margin-top: 10px;
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

        <div ng-show="settings.editCount > 0" class="alert alert-warning" role="alert">
            {/literal}{'Changes are saved !'|i18n('masev_settings')}{literal} <a ng-hide="settings.pendingCacheClear" ng-click="clearCache()">{/literal}{'Clear cache'|i18n('masev_settings')}{literal}</a> <img ng-show="settings.pendingCacheClear" src="/extension/masev_settings/design/standard/images/loading.gif" width="30px" />
        </div>

        <div class="row" ng-show="settings.xhrCount >= 2">
            <!-- Nav tabs -->
            <div class="col-md-3">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title">Catégories</h3>
                    </div>
                    <div ng-repeat="(level1, level2_sections) in settings.sections"  ng-class="{active: $index === 0}">
                            <div class="categorie">{{ level1|titlelize }}</div>
                            <div class="list-group" style="margin-left: 0">
                                <a ng-repeat="(level2, value) in level2_sections" class="list-group-item" ng-class='{active: ($parent.$index === 0 && $index === 0 && settings.activeTab == "") || settings.activeTab == "tab_"+level1+"_"+level2}' ng-click="displayTab(level1,level2)" aria-controls="settings">{{ level2|titlelize }} <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span></a>
                            </div>
                    </div>
                </div>
            </div>

            <!-- Tab panes -->
            <div class="col-md-9">
                <div ng-repeat="(key, level2_section) in settings.level2_sections" ng-show=" ($index === 0 && settings.activeTab == '') || settings.activeTab == 'tab_'+level2_section.level1+'_'+level2_section.name" ng-class="{active: $index === 0}" class="tab-pane" id="tab_{{level2_section.level1}}_{{level2_section.name}}">
                    <h2>{{ level2_section.name|titlelize }} <small>{{ level2_section.level1|titlelize }}</small></h2>

                    <div ng-repeat="(key, item) in settings.data" class="form-group">
                        <div ng-if="item.schema.form.type == 'text'" ng-show="item.schema.key.indexOf('.'+level2_section.name+'.') > -1 && item.schema.key.indexOf(level2_section.level1+'.') == 0">
                            <label for="{{ key }}">{{ item.schema.name }} :</label>
                            <span e-form="textBtnForm" id="{$key}" editable-text="item.data" onbeforesave="updateSettings(item, $data)" >{{ item.data == "" ? "Empty value, example : "+item.schema.default : item.data }}</span>
                            <button ng-show="!textBtnForm.$visible" class="btn btn-default" ng-click="textBtnForm.$show()">
                                edit
                            </button>
                        </div>
                        <div ng-if="item.schema.form.type == 'textarea'" ng-show="item.schema.key.indexOf('.'+level2_section.name+'.') > -1 && item.schema.key.indexOf(level2_section.level1+'.') == 0">
                            <label for="{{ key }}">{{ item.schema.name }} :</label><br />
                            <span e-form="textBtnForm" id="{$key}" editable-textarea="item.data" e-rows="{{ item.schema.form.options.rows }}" e-cols="{{ item.schema.form.options.cols }}"  onbeforesave="updateSettings(item, $data)" >{{ item.data == "" ? "Empty value, example : "+item.schema.default : item.data }}</span>
                            <button ng-show="!textBtnForm.$visible" class="btn btn-default" ng-click="textBtnForm.$show()">
                                edit
                            </button>
                        </div>
                        <div ng-if="item.schema.form.type == 'browseLocation'" ng-show="item.schema.key.indexOf('.'+level2_section.name+'.') > -1 && item.schema.key.indexOf(level2_section.level1+'.') == 0">
                            <label for="{{ key }}">{{ item.schema.name }} :</label><br />
                            <span e-form="textBtnForm" data-start-location-id="{{ item.schema.form.options.startLocationId }}" id="{$key}" editable-browse="item.data" onbeforesave="updateSettings(item, $data)" onaftersave="updateLabel(item, $data)">{{ item.data == "" ? "Empty value, example : "+item.schema.default : item.data }}</span>
                            <button ng-show="!textBtnForm.$visible" class="btn btn-default" ng-click="textBtnForm.$show()">
                                edit
                            </button>
                            <button ng-show="!textBtnForm.$visible" ng-click="deleteSettings(item, $data)" class="btn btn-default">
                                <span class="glyphicon glyphicon-trash"></span>
                                </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {/literal}
</div>