var pg_table = 'osm_peaks'

var peak_tags = {
    'natural': ['peak','volcano','peak;volcano'],
    'foo': ['bar']
}

var pg_insert = function () {


Osmium.Callbacks.node = function () {
    for (var key in peak_tags) {
        if this.tags.hasOwnProperty(key) {
            if peak_tags[key].indexOf(this.tags[key]) >= 0 {
                print(this.id);
            }
        }
    }
};

