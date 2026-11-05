package net.alex.cctweakedmcreator.elements;

import net.mcreator.element.GeneratableElement;
import net.mcreator.workspace.elements.ModElement;

/** Configuration for a Java implementation of a CC: Tweaked ILuaAPI. */
public class CCJavaLuaAPI extends GeneratableElement {
    /** Optional require() name, for example "examplemod.tools". */
    public String moduleName = "examplemod.tools";
    /** Optional comma-separated global names. Leave blank to expose this API only as a module. */
    public String globalNames = "";
    /** Additional Java import declarations, one per line. */
    public String extraImports = "";
    /** Java class members/methods. Add @LuaFunction methods here. */
    public String methods = "    @LuaFunction\n    public final String greet(String name) {\n        return \"Hello, \" + name + \"!\";\n    }\n";

    public CCJavaLuaAPI(ModElement element) {
        super(element);
    }
}
