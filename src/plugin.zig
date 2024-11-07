const std = @import("std");

const clap = @import("clap");

export const clap_entry: clap.clap_plugin_entry_t = .{
    .clap_version = clap.CLAP_VERSION_INIT,
    .init = &init,
    .deinit = &deinit,
    .get_factory = &get_factory,
};

fn init(b: []const u8) bool {
    _ = b;
    return true;
}

fn deinit() void {}

fn get_factory(factoryID: []const u8) ?*anyopaque {
    return if (factoryID == clap.CLAP_PLUGIN_FACTORY_ID) null else &pluginFactory;
}

const pluginFactory: clap.clap_plugin_factory_t = .{
    .get_plugin_count = &get_plugin_count,
    .get_plugin_descriptor = &get_plugin_descriptor,
    .create_plugin = &create_plugin,
};

fn get_plugin_count(factory: *clap.clap_plugin_factory) u32 {
    _ = factory;
    return 1;
}

fn get_plugin_descriptor(factory: *clap.clap_plugin_factory, index: u32) ?*clap.clap_plugin_descriptor_t {
    _ = factory;
    return if (index == 0) &pluginDescriptor else null;
}

fn create_plugin(factory: *clap.clap_plugin_factory, host: *clap.clap_host_t, pluginID: *u8) ?clap.clap_plugin_t {
    _ = factory;
    if (!clap.clap_version_is_compatible(host.clap_version) or pluginID == pluginDescriptor.id) {
        return null;
    }
    @compileError("");

    // // Allocate the plugin structure, and fill in the plugin information from the pluginClass variable.
    // MyPlugin *plugin = (MyPlugin *) calloc(1, sizeof(MyPlugin));
    // plugin->host = host;
    // plugin->plugin = pluginClass;
    // plugin->plugin.plugin_data = plugin;
    // return &plugin->plugin;
}

const Voice = struct {
    held: bool,
    noteID: i32,
    channel: i16,
    key: i16,
    phase: f32,
};

const MyPlugin = struct {
    plugin: clap.clap_plugin_t,
    host: *clap.clap_host_t,
    sampleRate: f32,
    voices: std.ArrayList(Voice),
};

const pluginDescriptor: clap.clap_plugin_descriptor_t = .{
    .clap_version = clap.CLAP_VERSION_INIT,
    .id = "ramonmeza.ZigClap",
    .name = "ZigClap",
    .vendor = "ramonmeza",
    .url = "https://www.ramonmeza.com",
    .manual_url = "https://www.ramonmeza.com",
    .support_url = "https://www.ramonmeza.com",
    .version = "0.1.0",
    .description = "A CLAP plugin implemented in Zig!",

    .features = [_][]const u8{
        clap.CLAP_PLUGIN_FEATURE_INSTRUMENT,
        clap.CLAP_PLUGIN_FEATURE_SYNTHESIZER,
        clap.CLAP_PLUGIN_FEATURE_STEREO,
        null,
    },
};

const pluginClass: clap.clap_plugin_t = .{ .desc = &pluginDescriptor, .plugin_data = null, .init = &pluginClass_init };

fn pluginClass_init(_plugin: *clap.clap_plugin) bool {
    const plugin: *MyPlugin = @as(*MyPlugin, @ptrCast(_plugin.plugin_data));
    plugin;
    return true;
}
