package net.alex.cctweakedmcreator.elements;

import net.mcreator.ui.MCreator;
import net.mcreator.ui.modgui.ModElementGUI;
import net.mcreator.ui.validation.AggregatedValidationResult;
import net.mcreator.workspace.elements.ModElement;

import javax.annotation.Nullable;
import javax.swing.*;
import java.awt.*;
import java.net.URI;
import java.net.URISyntaxException;

/** Simple source editor used by the different Lua ROM resource element types. */
public class CCLuaResourceGUI extends ModElementGUI<CCLuaResource> {
    private final JTextArea sourceEditor = new JTextArea(24, 80);

    public CCLuaResourceGUI(MCreator mcreator, ModElement modElement, boolean editingMode) {
        super(mcreator, modElement, editingMode);
        initGUI();
        super.finalizeGUI();
    }

    protected void initGUI() {
        sourceEditor.setFont(new Font(Font.MONOSPACED, Font.PLAIN, 13));
        sourceEditor.setTabSize(4);
        sourceEditor.setLineWrap(false);
        sourceEditor.setText("-- Add your CC: Tweaked Lua code here.\\n");

        JPanel panel = new JPanel(new BorderLayout(0, 8));
        panel.setOpaque(false);
        JLabel description = new JLabel("Lua source (written verbatim to the matching CC: Tweaked ROM folder)");
        description.setBorder(BorderFactory.createEmptyBorder(4, 4, 4, 4));
        panel.add(description, BorderLayout.NORTH);
        panel.add(new JScrollPane(sourceEditor), BorderLayout.CENTER);
        addPage("Lua source", panel).lazyValidate(() -> new AggregatedValidationResult.PASS());
    }

    public void openInEditingMode(CCLuaResource element) {
        sourceEditor.setText(element.sourceCode == null ? "" : element.sourceCode);
        sourceEditor.setCaretPosition(0);
    }

    public CCLuaResource getElementFromGUI() {
        CCLuaResource element = new CCLuaResource(this.modElement);
        element.sourceCode = sourceEditor.getText();
        return element;
    }

    @Override
    public @Nullable URI contextURL() throws URISyntaxException {
        return null;
    }
}
