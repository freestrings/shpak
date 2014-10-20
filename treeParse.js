"use strict";

var FS = require("q-io/fs");
var Q = require('q');
var path = require('path');
var parser = require('./parser.js');

function empty() {}

function joinPath(parent) {
    return function(file) {
        return path.join(parent, file);
    }
}

function toAbsPath(parent) {
    return function(files) {
        return files.map(joinPath(parent));
    };
}

function defaultPathFilter(file) {
    return /\.spec$/.test(file);
}

module.exports.walk = function(file, handler, filter) {

    var fileFilter = typeof filter === 'function' ? filter : defaultPathFilter;

    function parse(file) {
        if(!fileFilter(file)) return Q.fcall(empty);
        return parser.parse(file).then(handler).catch(function(err) {
            console.error('File : ', file, err);
            process.exit(-1);
        });
    }

    function list(file) {
        return FS.list(file).then(toAbsPath(file)).then(traverseAll);
    }

    function traverseAll(files) {
        return Q.all(files.map(traverse));
    }

    function traverse(file) {
        return FS.stat(file).then(function(stat) {
            return stat.isDirectory() ? list(file) : parse(file);
        });
    }

    return traverse(file);
};
