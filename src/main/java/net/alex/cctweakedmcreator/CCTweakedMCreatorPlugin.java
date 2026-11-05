package net.alex.cctweakedmcreator;

import net.alex.cctweakedmcreator.registry.CCTweakedElementTypes;
import net.mcreator.plugin.JavaPlugin;
import net.mcreator.plugin.Plugin;
import net.mcreator.plugin.events.PreGeneratorsLoadingEvent;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/** MCreator integration for authoring CC: Tweaked ROM resources and Lua APIs. */
public final class CCTweakedMCreatorPlugin extends JavaPlugin {

    private static final Logger LOG = LogManager.getLogger("CC: Tweaked MCreator Integration");

    public CCTweakedMCreatorPlugin(Plugin plugin) {
        super(plugin);
        addListener(PreGeneratorsLoadingEvent.class, event -> CCTweakedElementTypes.load());
        LOG.info("CC: Tweaked MCreator Integration loaded");
    }
}
