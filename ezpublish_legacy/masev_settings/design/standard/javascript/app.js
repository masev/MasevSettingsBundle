(function() {
    var app = angular.module('masevSettings', ['xeditable']);

    app.controller('BrowseController', ['$scope', '$http', '$element', function($scope, $http, $element) {
        var $browseWidgetElmt = angular.element($element);
        var $startLocationId = $browseWidgetElmt.parent().parent().parent().find("span").attr("data-start-location-id");
        $scope.items = [];
        $scope.noResult = false;
        $scope.loadingData = false;
        if (typeof $scope.nodeIdPath == "undefined") {
            $scope.nodeIdPath = [];
            $scope.nodeIdPath[0] = $startLocationId;
        }
        if (typeof $scope.depth == "undefined") {
            $scope.depth = 0;
        }

        $scope.loadingData = true;
        $http.get('/'+currentSiteAccess+'/ezjscore/call/ezjscnode::subtree::'+$startLocationId+'::100::0::priority::1::?ContentType=json').
          then(function(response) {
            if (response.data.content.total_count != 0) {
                $scope.items = response.data.content.list;
            } else {
                $scope.noResult = true;
            }
            $scope.loadingData = false;
          }, function(response) {
            console.log(response);
            $scope.loadingData = false;
        });

        $scope.unEscapeHtml = function(unsafe) {
            return unsafe
                .replace(/&lt;/g, "<")
                .replace(/&gt;/g, ">")
                .replace(/&cent;/g, "¢")
                .replace(/&pound;/g, "£")
                .replace(/&euro;/g, "€")
                .replace(/&yen;/g, "¥")
                .replace(/&deg;/g, "°")
                .replace(/&frac14;/g, "¼")
                .replace(/&OElig;/g, "Œ")
                .replace(/&frac12;/g, "½")
                .replace(/&oelig;/g, "œ")
                .replace(/&frac34;/g, "¾")
                .replace(/&Yuml;/g, "Ÿ")
                .replace(/&iexcl;/g, "¡")
                .replace(/&laquo;/g, "«")
                .replace(/&raquo;/g, "»")
                .replace(/&iquest;/g, "¿")
                .replace(/&Agrave;/g, "À")
                .replace(/&Aacute;/g, "Á")
                .replace(/&Acirc;/g, "Â")
                .replace(/&Atilde;/g, "Ã")
                .replace(/&Auml;/g, "Ä")
                .replace(/&Aring;/g, "Å")
                .replace(/&AElig;/g, "Æ")
                .replace(/&Ccedil;/g, "Ç")
                .replace(/&Egrave;/g, "È")
                .replace(/&Eacute;/g, "É")
                .replace(/&Ecirc;/g, "Ê")
                .replace(/&Euml;/g, "Ë")
                .replace(/&Igrave;/g, "Ì")
                .replace(/&Iacute;/g, "Í")
                .replace(/&Icirc;/g, "Î")
                .replace(/&Iuml;/g, "Ï")
                .replace(/&ETH;/g, "Ð")
                .replace(/&Ntilde;/g, "Ñ")
                .replace(/&Ograve;/g, "Ò")
                .replace(/&Oacute;/g, "Ó")
                .replace(/&Ocirc;/g, "Ô")
                .replace(/&Otilde;/g, "Õ")
                .replace(/&Ouml;/g, "Ö")
                .replace(/&Oslash;/g, "Ø")
                .replace(/&Ugrave;/g, "Ù")
                .replace(/&Uacute;/g, "Ú")
                .replace(/&Ucirc;/g, "Û")
                .replace(/&Uuml;/g, "Ü")
                .replace(/&Yacute;/g, "Ý")
                .replace(/&THORN;/g, "Þ")
                .replace(/&szlig;/g, "ß")
                .replace(/&agrave;/g, "à")
                .replace(/&aacute;/g, "á")
                .replace(/&acirc;/g, "â")
                .replace(/&atilde;/g, "ã")
                .replace(/&auml;/g, "ä")
                .replace(/&aring;/g, "å")
                .replace(/&aelig;/g, "æ")
                .replace(/&ccedil;/g, "ç")
                .replace(/&egrave;/g, "è")
                .replace(/&eacute;/g, "é")
                .replace(/&ecirc;/g, "ê")
                .replace(/&euml;/g, "ë")
                .replace(/&igrave;/g, "ì")
                .replace(/&iacute;/g, "í")
                .replace(/&icirc;/g, "î")
                .replace(/&iuml;/g, "ï")
                .replace(/&eth;/g, "ð")
                .replace(/&ntilde;/g, "ñ")
                .replace(/&ograve;/g, "ò")
                .replace(/&oacute;/g, "ó")
                .replace(/&ocirc;/g, "ô")
                .replace(/&otilde;/g, "õ")
                .replace(/&ouml;/g, "ö")
                .replace(/&oslash;/g, "ø")
                .replace(/&ugrave;/g, "ù")
                .replace(/&uacute;/g, "ú")
                .replace(/&ucirc;/g, "û")
                .replace(/&uuml;/g, "ü")
                .replace(/&yacute;/g, "ý")
                .replace(/&thorn;/g, "þ")
                .replace(/&quot;/g, "\"")
                .replace(/'/g, "'")
                .replace(/&amp;/g, "&");
        };

        $scope.browse = function($nodeId, $back) {
            $scope.loadingData = true;
            $http.get('/'+currentSiteAccess+'/ezjscore/call/ezjscnode::subtree::'+$nodeId+'::100::0::priority::1::?ContentType=json').
              then(function(response) {
                if (response.data.content.total_count != 0) {
                    $scope.items = response.data.content.list;
                    $scope.noResult = false;
                } else {
                    $scope.noResult = true;
                }
                if (!$back) {
                    $scope.depth++;
                    $scope.nodeIdPath[$scope.depth] = $nodeId;
                }
                $scope.loadingData = false;
              }, function(response) {
                console.log(response);
                $scope.loadingData = false;
            });
        };

        $scope.back = function() {
            $scope.depth--;
            $scope.browse($scope.nodeIdPath[$scope.depth], true);
        };
    }]);

    app.controller('SettingsController', ['$scope', '$http', function($scope, $http, $log){
        var that = this;

        that.sections = {};
        that.level2_sections = [];
        that.data = [];
        that.xhrCount = -1;
        that.site = "";
        that.editCount = 0;
        that.pendingCacheClear = 0;
        that.activeTab = "";

        $scope.updateSettings = function(item, data) {
            that.editCount++;
            return $http.post('api/update', {"item": item, "value": data, "site": that.site});
        };

        $scope.displayTab = function(level1, level2) {
            that.activeTab = "tab_"+level1+"_"+level2;
            return false;
        };

        $scope.generateTable = function(site) {
            that.sections = {};
            that.level2_sections = [];
            that.data = [];
            that.xhrCount = 0;
            that.site = site;

            $http.get('api/sections').success(function(data) {
                for (section in data) {
                    for (level2 in data[section]) {
                        that.level2_sections.push({"name":level2, "level1": section});
                    }
                }
                that.sections = data;
                that.xhrCount++;
            });

            $http.get('api/data', {"params": {"site": that.site}}).success(function(data) {
                that.data = data;
                that.xhrCount++;
            });
        };

        $scope.clearCache = function(item, data) {
            that.pendingCacheClear = 1;
            $http.get('api/clearCache').success(function() {
                that.editCount = 0;
                that.pendingCacheClear = 0;
            });
        };
    }]);

    app.filter('titlelize', function() {
        return function(input) {
            return (!!input) ? (input.charAt(0).toUpperCase() + input.substr(1).toLowerCase()).replace(/_/g, ' ') : '';
        }
    });

    app.run(function(editableOptions) {
        editableOptions.theme = 'bs3'; // bootstrap3 theme. Can be also 'bs2', 'default'
    });
})();