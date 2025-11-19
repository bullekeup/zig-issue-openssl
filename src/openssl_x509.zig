const std = @import("std");

pub const log_level = std.log.Level.debug;

pub const c = @cImport({
    @cInclude("openssl/x509.h");
    @cInclude("openssl/pem.h");
});

pub fn main() void {
    std.log.info("*Start test*", .{});

    const file = c.BIO_new_file("Amazon_Root_CA_1.crt", "r");
    if (file == null) {
        std.log.err("Failed to open file", .{});
        return;
    }
    defer {
        const rc = c.BIO_free(file);
        if (rc == 0) {
            std.log.err("Failed to close file", .{});
        }
    }

    const cert = c.PEM_read_bio_X509(
        file,
        null,
        null,
        null,
    );
    if (cert == null) {
        std.log.err("Failed to read certificate", .{});
        return;
    }
    defer c.X509_free(cert);

    const subject = c.X509_get_subject_name(cert);
    if (subject == null) {
        std.log.err("Failed to get subject", .{});
        return;
    }

    const cn_id = c.X509_NAME_get_index_by_NID(subject, c.NID_commonName, -1);
    if (cn_id < 0) {
        std.log.err("Failed to get common name: {d}", .{cn_id});
        return;
    }

    const cn_entry = c.X509_NAME_get_entry(subject, cn_id);
    if (cn_entry == null) {
        std.log.err("Failed to get common name", .{});
        return;
    }

    const cn_data = c.X509_NAME_ENTRY_get_data(cn_entry);
    if (cn_data == null) {
        std.log.err("Failed to get common name", .{});
        return;
    }
    std.log.info("Common name: {s}", .{cn_data.*.data});

    std.log.info("Certificate read successfully", .{});
    return;
}
