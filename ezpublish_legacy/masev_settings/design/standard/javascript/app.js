(function() {
    var app = angular.module('masevSettings', ['xeditable']);

    app.controller('BrowseController', ['$scope', '$http', function($scope, $http) {
        $scope.items = [];
        $scope.noResult = false;
        if (typeof $scope.nodeIdPath == "undefined") {
            $scope.nodeIdPath = [];
            $scope.nodeIdPath[0] = 2;
        }
        if (typeof $scope.depth == "undefined") {
            $scope.depth = 0;
        }

        $http.get('/administration/ezjscore/call/ezjscnode::subtree::2::100::0::priority::1::?ContentType=json').
          then(function(response) {
            if (response.data.content.total_count != 0) {
                $scope.items = response.data.content.list;
            } else {
                $scope.noResult = true;
            }
          }, function(response) {
            console.log(response);
        });

        $scope.browse = function($nodeId, $back) {
            $http.get('/administration/ezjscore/call/ezjscnode::subtree::'+$nodeId+'::100::0::priority::1::?ContentType=json').
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
                console.log($scope.nodeIdPath);
              }, function(response) {
                console.log(response);
            });
        };

        $scope.back = function() {
            $scope.depth--;
            console.log($scope.depth);
            console.log($scope.nodeIdPath[$scope.depth]);
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

        $scope.updateSettings = function(item, data) {
            that.editCount++;
            return $http.post('api/update', {"item": item, "value": data, "site": that.site});
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

    app.run(function(editableOptions) {
        editableOptions.theme = 'bs3'; // bootstrap3 theme. Can be also 'bs2', 'default'
    });
})();