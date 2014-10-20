#!/usr/bin/env node
"use strict";

var argv = require('optimist')
    .usage('Usage: $0 --file <<file_path>> --output(optional) <<output_path>>')
    .demand(['file'])
    .argv;

var fs = require('fs');
var path = require('path');
var mkdirp = require('mkdirp');
var baseDir = fs.statSync(argv.file).isDirectory() ? argv.file : path.dirname(argv.file);

require('./treeParse.js').walk(argv.file, processResult).then(onSuccess).catch(onFailure);

function processResult(result) {
    if(argv.output) {
        write(argv.output, result.file, result.data);
    } else {
        console.log(result.file);
        console.log(beautyfy(result.data));
        console.log();
    }
}

function onSuccess() {
    console.log('Done');
}

function onFailure(err) {
    console.error('Error----------------> ', err);
}

function beautyfy(data) {
    return JSON.stringify(data, null, 2);
}

function write(dist, file, data) {
    var target = path.join(__dirname, dist, file.replace(baseDir, ''));
    mkdirp(path.dirname(target), function(err) {

        if(err) {
            console.error(err);
            return;
        }

        fs.writeFile(target, beautyfy(data), function(err) {
            if(err) {
                console.error(err);
                return;
            }

            console.log('Write Done->', target);
        });
    });
}
