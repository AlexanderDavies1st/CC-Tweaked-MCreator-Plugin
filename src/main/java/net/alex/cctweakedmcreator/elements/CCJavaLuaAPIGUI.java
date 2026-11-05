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

/** Editor for a Java-backed CC: Tweaked Lua API. */
public class CCJavaLuaAPIGUI extends ModElementGUI<CCJavaLuaAPI> {
    private final JTextField moduleName = new JTextField("examplemod.tools", 40);
    private final JTextField globalNames = new JTextField("", 40);
    private final JTextArea extraImports = new JTextArea(4, 70);
    private final JTextArea methods = new JTextArea(18, 70);

    public CCJavaLuaAPIGUI(MCreator mcreator, ModElement modElement, boolean editingMode) {
        super(mcreator, modElement, editingMode);
        initGUI();
        super.finalizeGUI();
    }

    protected void initGUI() {
        moduleName.setToolTipText("Module name passed to require(), e.g. examplemod.tools");
        globalNames.setToolTipText("Comma-separated globals, e.g. myapi, my_tools. Leave blank for no globals.");
        extraImports.setFont(new Font(Font.MONOSPACED, Font.PLAIN, 12));
        extraImports.setTabSize(4);
        methods.setFont(new Font(Font.MONOSPACED, Font.PLAIN, 13));
        methods.setTabSize(4);
        methods.setText("    @LuaFunction\n    public final String greet(String name) {\n        return \"Hello, \" + name + \"!\";\n    }\n");

        JPanel properties = new JPanel(new GridBagLayout());
        properties.setOpaque(false);
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(4, 5, 4, 5);
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.weightx = 1;
        gbc.gridx = 0;
        gbc.gridy = 0;
        properties.add(new JLabel("Lua module name (optional)"), gbc);
        gbc.gridy++;
        properties.add(moduleName, gbc);
        gbc.gridy++;
        properties.add(new JLabel("Global names (comma-separated, optional)"), gbc);
        gbc.gridy++;
        properties.add(globalNames, gbc);

        JPanel codePanel = new JPanel(new BorderLayout(0, 5));
        codePanel.setOpaque(false);
        codePanel.add(new JLabel("Additional Java imports (one import declaration per line)"), BorderLayout.NORTH);
        codePanel.add(new JScrollPane(extraImports), BorderLayout.CENTER);

        JPanel methodsPanel = new JPanel(new BorderLayout(0, 5));
        methodsPanel.setOpaque(false);
        methodsPanel.add(new JLabel("Java class members and @LuaFunction methods"), BorderLayout.NORTH);
        methodsPanel.add(new JScrollPane(methods), BorderLayout.CENTER);

        JPanel content = new JPanel();
        content.setOpaque(false);
        content.setLayout(new BoxLayout(content, BoxLayout.Y_AXIS));
        content.add(properties);
        content.add(Box.createVerticalStrut(8));
        content.add(codePanel);
        content.add(Box.createVerticalStrut(8));
        content.add(methodsPanel);
        addPage("Java Lua API", new JScrollPane(content)).lazyValidate(() -> new AggregatedValidationResult.PASS());
    }

    public void openInEditingMode(CCJavaLuaAPI element) {
        moduleName.setText(element.moduleName == null ? "" : element.moduleName);
        globalNames.setText(element.globalNames == null ? "" : element.globalNames);
        extraImports.setText(element.extraImports == null ? "" : element.extraImports);
        methods.setText(element.methods == null ? "" : element.methods);
    }

    public CCJavaLuaAPI getElementFromGUI() {
        CCJavaLuaAPI element = new CCJavaLuaAPI(this.modElement);
        element.moduleName = moduleName.getText().trim();
        element.globalNames = globalNames.getText().trim();
        element.extraImports = extraImports.getText();
        element.methods = methods.getText();
        return element;
    }

    @Override
    public @Nullable URI contextURL() throws URISyntaxException {
        return null;
    }
}
