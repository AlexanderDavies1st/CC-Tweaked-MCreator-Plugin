package net.alex.cctweakedmcreator.elements;

import net.mcreator.element.GeneratableElement;
import net.mcreator.workspace.elements.ModElement;

/** Source model shared by the Lua program, module, API, startup and help elements. */
public class CCLuaResource extends GeneratableElement {
    /** Raw Lua source; written verbatim into the generated resource. */
    public String sourceCode = "-- Add your CC: Tweaked Lua code here.\\n";

    public CCLuaResource(ModElement element) {
        super(element);
    }
}
