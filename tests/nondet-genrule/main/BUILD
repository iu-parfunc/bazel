genrule(
    name = "evil-gen",
    srcs = [],
    outs = ["evil.h"],
    cmd = "./$(location spawn_evil.sh) > \"$@\"",
    tools = ["spawn_evil.sh"],
)

cc_binary(
    name = "nondet-genrule",
    srcs = ["nondet-genrule.c", "evil.h"],
)
