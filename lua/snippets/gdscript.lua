local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

local snippets = {
	s("exp", {
		t("@export var "),
		i(1, "name"),
		t(": "),
		i(2, "int"),
	}),

	-- signal
	s("sig", {
		t("signal "),
		i(1, "my_signal"),
	}),

	-- enum Name { A, B, C }
	s("enu", {
		t("enum "),
		i(1, "MyEnum"),
		t(" { "),
		i(2, "A, B, C"),
		t(" }"),
	}),

	-- const NAME = VALUE
	s("const", {
		t("const "),
		i(1, "NAME"),
		t(" = "),
		i(2, "value"),
	}),

	-- extends Node
	s("ext", {
		t("extends "),
		i(1, "Node"),
	}),

	-- class_name MyClass
	s("cls", {
		t("class_name "),
		i(1, "MyClass"),
	}),

	-- @onready var name = $Node
	s("ready", {
		t("@onready var "),
		i(1, "my_var"),
		t(" = $"),
		i(2, "Node"),
	}),
}

local autosnippets = {}

return snippets, autosnippets
