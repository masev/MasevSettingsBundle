(function() {
    var app = angular.module('masevSettings', ['xeditable']);

    app.controller('SettingsController', ['$scope', '$http', function($scope, $http, $log){
        var that = this;

        that.sections = {};
        that.level2_sections = [];
        that.data = [];
        that.xhrCount = 0;

        $http.get('/masev_settings/api/sections').success(function(data) {
            for (section in data) {
                for (level2 in data[section]) {
                    that.level2_sections.push({"name":level2, "level1": section});
                }
            }
            that.sections = data;
            that.xhrCount++;
        });

        $http.get('/masev_settings/api/data').success(function(data) {
            that.data = data;
            that.xhrCount++;
            console.log(that.xhrCount);
        });

        $scope.updateSettings = function(item, data) {
            return $http.post('/masev_settings/api/update', {item: item, value: data});
        };
    }]);

    app.run(function(editableOptions) {
        editableOptions.theme = 'bs3'; // bootstrap3 theme. Can be also 'bs2', 'default'
    });
})();