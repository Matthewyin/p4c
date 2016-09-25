#include <core.p4>
#include <v1model.p4>

header hdr {
    int<32> a;
    bit<8>  b;
    int<64> c;
}

struct Headers {
    hdr h;
}

struct Meta {
}

parser p(packet_in b, out Headers h, inout Meta m, inout standard_metadata_t sm) {
    state start {
        b.extract<hdr>(h.h);
        transition accept;
    }
}

control vrfy(in Headers h, inout Meta m, inout standard_metadata_t sm) {
    apply {
    }
}

control update(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    apply {
    }
}

control egress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    apply {
    }
}

control deparser(packet_out b, in Headers h) {
    apply {
        b.emit<hdr>(h.h);
    }
}

control ingress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    @name("tmp") int<32> tmp_0;
    @name("shift") action shift_0() {
        tmp_0 = h.h.a >> h.h.b;
        h.h.c = (int<64>)tmp_0;
        sm.egress_spec = 9w0;
    }
    @name("t") table t() {
        actions = {
            shift_0();
        }
        const default_action = shift_0();
    }
    apply {
        t.apply();
    }
}

V1Switch<Headers, Meta>(p(), vrfy(), ingress(), egress(), update(), deparser()) main;