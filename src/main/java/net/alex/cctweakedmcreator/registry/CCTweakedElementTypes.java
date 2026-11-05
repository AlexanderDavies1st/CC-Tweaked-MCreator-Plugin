package net.alex.cctweakedmcreator.registry;

import net.alex.cctweakedmcreator.elements.CCLuaResource;
import net.alex.cctweakedmcreator.elements.CCLuaResourceGUI;
import net.alex.cctweakedmcreator.elements.CCJavaLuaAPI;
import net.alex.cctweakedmcreator.elements.CCJavaLuaAPIGUI;
import net.mcreator.element.ModElementType;

import static net.mcreator.element.ModElementTypeLoader.register;

/** Registers the custom mod-element types exposed by this plugin. */
public final class CCTweakedElementTypes {
    public static ModElementType<?> LUA_PROGRAM;
    public static ModElementType<?> LUA_MODULE;
    public static ModElementType<?> LUA_API;
    public static ModElementType<?> LUA_HTTP_API;
    public static ModElementType<?> LUA_TURTLE_API;
    public static ModElementType<?> LUA_POCKET_API;
    public static ModElementType<?> LUA_COMMAND_API;
    public static ModElementType<?> LUA_AUTORUN;
    public static ModElementType<?> LUA_HELP;
    public static ModElementType<?> JAVA_LUA_API;

    private CCTweakedElementTypes() {}

    public static void load() {
        LUA_PROGRAM = register(new ModElementType<>("cctweaked_lua_program", (Character) 'P', CCLuaResourceGUI::new, CCLuaResource.class));
        LUA_MODULE = register(new ModElementType<>("cctweaked_lua_module", (Character) 'M', CCLuaResourceGUI::new, CCLuaResource.class));
        LUA_API = register(new ModElementType<>("cctweaked_lua_api", (Character) 'A', CCLuaResourceGUI::new, CCLuaResource.class));
        LUA_HTTP_API = register(new ModElementType<>("cctweaked_lua_http_api", (Character) 'W', CCLuaResourceGUI::new, CCLuaResource.class));
        LUA_TURTLE_API = register(new ModElementType<>("cctweaked_lua_turtle_api", (Character) 'T', CCLuaResourceGUI::new, CCLuaResource.class));
        LUA_POCKET_API = register(new ModElementType<>("cctweaked_lua_pocket_api", (Character) 'K', CCLuaResourceGUI::new, CCLuaResource.class));
        LUA_COMMAND_API = register(new ModElementType<>("cctweaked_lua_command_api", (Character) 'C', CCLuaResourceGUI::new, CCLuaResource.class));
        LUA_AUTORUN = register(new ModElementType<>("cctweaked_lua_autorun", (Character) 'U', CCLuaResourceGUI::new, CCLuaResource.class));
        LUA_HELP = register(new ModElementType<>("cctweaked_lua_help", (Character) 'H', CCLuaResourceGUI::new, CCLuaResource.class));
        JAVA_LUA_API = register(new ModElementType<>("cctweaked_java_lua_api", (Character) 'J', CCJavaLuaAPIGUI::new, CCJavaLuaAPI.class));
    }
}
