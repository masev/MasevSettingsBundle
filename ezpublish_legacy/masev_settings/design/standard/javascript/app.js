(function() {
    var app = angular.module('masevSettings', ['xeditable']);

    app.controller('SettingsController', ['$scope', '$http', function($scope, $http, $log){
        var that = this;

        that.sections = {};
        that.level2_sections = [];
        that.data = [];
        that.xhrCount = -1;
        that.site = "";
        that.editCount = 0;

        $scope.updateSettings = function(item, data) {
            that.editCount++;
            return $http.post('/masev_settings/api/update', {"item": item, "value": data, "site": that.site});
        };

        $scope.generateTable = function(site) {
            that.sections = {};
            that.level2_sections = [];
            that.data = [];
            that.xhrCount = 0;
            that.site = site;

            $http.get('/masev_settings/api/sections').success(function(data) {
                for (section in data) {
                    for (level2 in data[section]) {
                        that.level2_sections.push({"name":level2, "level1": section});
                    }
                }
                that.sections = data;
                that.xhrCount++;
            });

            $http.get('/masev_settings/api/data', {"params": {"site": that.site}}).success(function(data) {
                that.data = data;
                that.xhrCount++;
            });
        };

        $scope.clearCache = function(item, data) {
            that.editCount = 0;
        };

    }]);

    app.run(function(editableOptions) {
        editableOptions.theme = 'bs3'; // bootstrap3 theme. Can be also 'bs2', 'default'
    });
})();