"use strict";

var FS = require("q-io/fs");
var fs = require("fs");
var path = require("path");
var jison = require("jison");
var bnf = fs.readFileSync("shpak.jison", "utf8");
var commentBnf = fs.readFileSync("shpakComment.jison", "utf8");
var parser = new jison.Parser(bnf);
var commentParser = new jison.Parser(commentBnf);

parser.yy = {};
parser.yy.Type = Type;
commentParser.yy.Comment = Comment;

function merge(obj1, obj2) {
    var obj3 = {};
    for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
    for (var attrname in obj2) { obj3[attrname] = obj2[attrname]; }
    return obj3;
}

function Comment(name, value) {
    this.namedComment = {};
    this.comments = [];
    if(name) {
        this.namedComment[name] = value;
    } else {
        this.comments.push(value);
    }
}

Comment.prototype.add = function(name, value) {
    this.namedComment = merge(this.namedComment, name.namedComment);
    this.comments = this.comments.concat(name.comments);
};

function Type(type, name, isOptional, children, parameters, _extends) {
    this.type = type;
    if(name) this.name = name;
    if(isOptional) this.isOptional = isOptional;
    if(children && children.length > 0) this.children = children;
    if(parameters) this.parameters = parameters;
    if(_extends) this._extends = _extends;
}

Type.prototype.setComment = function(comment) {
    this.comments = commentParser.parse(comment.join('\n'));
};

module.exports.parse = function(file) {
    return FS.read(file).then(function(data) {
        return { file: file, data: parser.parse(data) };
    });
};
