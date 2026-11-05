package ${package}.cctweaked;

import dan200.computercraft.api.ComputerCraftAPI;
import dan200.computercraft.api.lua.ILuaAPI;
import dan200.computercraft.api.lua.LuaFunction;
import net.neoforged.bus.api.SubscribeEvent;
import net.neoforged.fml.common.EventBusSubscriber;
import net.neoforged.fml.event.lifecycle.FMLCommonSetupEvent;

<#if data.extraImports?has_content>
${data.extraImports}
</#if>

@EventBusSubscriber(modid = "${modid}")
public final class ${name}CCTLuaAPI implements ILuaAPI {
    @Override
    public String[] getNames() {
        <#assign globals = []>
        <#list (data.globalNames!"")?split(",") as item>
            <#if item?trim?has_content>
                <#assign globals = globals + [item?trim]>
            </#if>
        </#list>
        return new String[] {
            <#list globals as globalName>
                "${globalName?j_string}"<#if globalName_has_next>,</#if>
            </#list>
        };
    }

    @Override
    public String getModuleName() {
        <#if (data.moduleName!"")?trim?has_content>
        return "${data.moduleName?trim?j_string}";
        <#else>
        return null;
        </#if>
    }

    @SubscribeEvent
    public static void onCommonSetup(FMLCommonSetupEvent event) {
        event.enqueueWork(() -> ComputerCraftAPI.registerAPIFactory(computer -> new ${name}CCTLuaAPI()));
    }

    // Add Java fields and @LuaFunction methods in the MCreator element editor.
${data.methods!""}
}
