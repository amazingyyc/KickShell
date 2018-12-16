import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    /**store the shell info*/
    let ShellInfoKey: String = "shell_info_key"

    /**the size of Window*/
    let WindowWidth: CGFloat  = 500
    let WindowHeight: CGFloat = 400;
    
    let BorderMargin: CGFloat = 20;
    
    let TableViewWidth: CGFloat = 150;
    
    /**the shell command info*/
    var shellInfo: [Dictionary<String, String>]?
    
    /**status bar item*/
    var statusItem: NSStatusItem!
    
    /**the status menu*/
    var statusMenu: NSMenu!
    
    /**the tableView*/
    var tableScollView: NSScrollView!
    
    var tableView: NSTableView!

    @IBOutlet var terminalLabel: NSTextField!
    @IBOutlet var terminalMenu: NSPopUpButton!
    @IBOutlet var titleLabel: NSTextField!
    @IBOutlet var titleFeild: NSTextField!
    @IBOutlet var pathLabel: NSTextField!
    @IBOutlet var pathFeild: NSTextField!
    @IBOutlet var commandLabel: NSTextField!
    @IBOutlet var commandFeild: NSTextField!
    @IBOutlet var finishButton: NSButton!
    @IBOutlet var deleteButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**read info*/
        shellInfo = getShellInfo()

        initStatusBar()
        initTableView()
        ifShowEditPanel()
        
        /**
         * use this mehtod to hidden the main Window, find some other method but not working
         */
        DispatchQueue.main.async {
            self.view.window?.orderOut(nil)
        }
    }
    
    private func initTableView() {
        tableScollView = NSScrollView.init()
        tableScollView.hasVerticalScroller = true
        tableScollView.hasHorizontalScroller = false
        tableScollView.autohidesScrollers = true
        
        tableScollView.frame = NSRect.init(x: BorderMargin, y: 3 * BorderMargin, width: TableViewWidth, height: WindowHeight - 5 * BorderMargin)
        
        tableView = NSTableView.init(frame: tableScollView.bounds)
        
        let tableColumn = NSTableColumn.init(identifier: NSUserInterfaceItemIdentifier.init("TableColumn"))
        
        tableView.addTableColumn(tableColumn)
        tableView.headerView = nil
        
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.reloadData()
        
        tableScollView.contentView.documentView = tableView
        
        self.view.addSubview(tableScollView)
        
        if (nil != shellInfo && shellInfo!.count > 0) {
            tableView.selectRowIndexes(IndexSet.init(integer: 0), byExtendingSelection: false)
             showShellInfo(row: 0)
        }
    }
    
    private func showShellInfo(row: Int) {
        if (nil != shellInfo && 0 <= row && row < shellInfo!.count) {
            let dict = shellInfo![row];
            
            if (nil != dict["terminal"] && nil != dict["title"] && nil != dict["path"] && nil != dict["command"]) {
                showShellInfo(terminal: dict["terminal"]!, title: dict["title"]!, path: dict["path"]!, command: dict["command"]!)
            }
        }
    }
    
    private func showShellInfo(terminal: String, title: String, path: String, command: String) {
        if (terminal.lowercased() == "iterm2") {
            terminalMenu.selectItem(at: 0)
        } else {
            terminalMenu.selectItem(at: 1)
        }
        
        titleFeild.stringValue = title
        pathFeild.stringValue = path
        commandFeild.stringValue = command
    }
    
    private func ifShowEditPanel() {
        if (nil == shellInfo || 0 == shellInfo!.count) {
            terminalLabel.isHidden = true
            terminalMenu.isHidden = true
            titleLabel.isHidden = true
            titleFeild.isHidden = true
            pathLabel.isHidden = true
            pathFeild.isHidden = true
            commandLabel.isHidden = true
            commandFeild.isHidden = true
            finishButton.isHidden = true
            deleteButton.isHidden = true
        } else {
            terminalLabel.isHidden = false
            terminalMenu.isHidden = false
            titleLabel.isHidden = false
            titleFeild.isHidden = false
            pathLabel.isHidden = false
            pathFeild.isHidden = false
            commandLabel.isHidden = false
            commandFeild.isHidden = false
            finishButton.isHidden = false
            deleteButton.isHidden = false
        }
    }
    
    /**table view delegate*/
    public func numberOfRows(in tableView: NSTableView) -> Int {
        if (nil == shellInfo) {
            return 0;
        }
        
        return shellInfo!.count
    }
    
    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        showShellInfo(row: row)

        return true
    }

    public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 35
    }

    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier.init("TableColumn")
        
        var cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTextField
        
        if (nil == cell) {
            cell = NSTextField.init(frame: NSRect.zero)
            cell?.backgroundColor = NSColor.clear
            cell?.identifier = identifier
        }
        
        cell?.maximumNumberOfLines = 1
        cell?.backgroundColor = NSColor.clear
        cell?.isBordered = false
        cell?.isEditable = false
        cell?.alignment = NSTextAlignment.justified
        cell?.font = NSFont.systemFont(ofSize: 15)
        
        if (nil != shellInfo && row >= 0 && row < shellInfo!.count) {
            if (nil != shellInfo![row]["title"]) {
                cell?.stringValue = shellInfo![row]["title"]!
            }
        }
        
        return cell
    }
    
    private func initStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        let icon = NSImage.init(named: "status_icon")
        icon?.isTemplate = true
        
        statusItem.button?.image = icon
        statusItem.button?.imageScaling = NSImageScaling.scaleProportionallyUpOrDown
        
        statusMenu = NSMenu()
        statusItem.menu = statusMenu
        
        /**update status menu*/
        updateStatusMenu()
    }
    
    private func updateStatusMenu() {
        statusMenu.removeAllItems()

        if nil != shellInfo {
            var count: Int = 0;
            for item in shellInfo! {
                if nil != item["title"] && nil != item["path"] && nil != item["command"] {
                    let menuItem = NSMenuItem.init(title: item["title"]!, action: #selector(onMenuItemClick(_:)), keyEquivalent: "\(count + 1)")
                    menuItem.target = self
                    menuItem.tag = count
                    
                    statusMenu.addItem(menuItem)
                    
                    count += 1;
                }
            }
            
            if (count > 0) {
                statusMenu.addItem(NSMenuItem.separator())
            }
        }
        
        /**add setting and exit item*/
        let settingItem = NSMenuItem.init(title: "Setting", action: #selector(onMenuItemClick(_:)), keyEquivalent: "s")
        settingItem.target = self
        settingItem.tag = -1;
        
        let exitItem = NSMenuItem.init(title: "Exit", action: #selector(onMenuItemClick(_:)), keyEquivalent: "e")
        exitItem.target = self
        exitItem.tag = -2;
        
        statusMenu.addItem(settingItem)
        statusMenu.addItem(exitItem)
    }
    
    /**read the shell info from file*/
    private func getShellInfo() -> [Dictionary<String, String>]? {
        if let info = UserDefaults.standard.array(forKey: ShellInfoKey) {
            return info as? [Dictionary<String, String>]
        }
        
        return nil
    }
    
    private func dumpToFile(shellInfos: [Dictionary<String, String>]?) {
        UserDefaults.standard.set(shellInfos, forKey: ShellInfoKey)
    }

    @objc func onMenuItemClick(_ sender: NSMenuItem) {
        if (-1 == sender.tag) {
            self.view.window?.makeKeyAndOrderFront(self)
            NSApp.activate(ignoringOtherApps: true)
        } else if (-2 == sender.tag) {
            NSApp.terminate(self)
        } else {
            let tag = sender.tag
            
            if nil != shellInfo && 0 <= tag && tag < shellInfo!.count {
                if nil != shellInfo![tag]["path"] && nil != shellInfo![tag]["command"] {
                    if (nil != shellInfo![tag]["terminal"] && "terminal" == shellInfo![tag]["terminal"]) {
                        runTerminalScript(path: shellInfo![tag]["path"]!, command: shellInfo![tag]["command"]!)
                    } else if (nil != shellInfo![tag]["terminal"] && "iterm2" == shellInfo![tag]["terminal"]) {
                        runIterm2Script(path: shellInfo![tag]["path"]!, command: shellInfo![tag]["command"]!)
                    }
                }
            }
        }
    }
    
    /**
     * use the iTerm2 to run the command
     */
    func runIterm2Script(path: String, command: String) {
        let script = """
            on run argv
                tell application "iTerm"
                    activate
                    set curwindow to current window
                    if curwindow is equal to missing value then
                        set curwindow to (create window with default profile)
                    else
                        tell curwindow
                            create tab with default profile
                        end tell
                    end if
                    set cursession to (current session of curwindow)
                    tell cursession to write text "cd \(path); clear; pwd; \(command);"
                end tell
            end run
        """
        
        var error: NSDictionary?
        
        if let scriptObject = NSAppleScript(source: script) {
            if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error) {
                /**print output*/
                print(output.stringValue)
            } else if (error != nil) {
                runError(type: "iTerm2", info: "error: \(error)")
            }
        }
    }
    
    /**
     * use the terminal to run command
     */
    func runTerminalScript(path: String, command: String) {
        let script = """
            tell application "Terminal"
                activate
                set currentTab to do script ("cd \(path); clear; pwd; \(command);")
            end tell
        """

        var error: NSDictionary?
        
        if let scriptObject = NSAppleScript(source: script) {
            if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error) {
                /**print output*/
                print(output.stringValue)
            } else if (error != nil) {
                runError(type: "Termianl", info: "error: \(error)")
            }
        }
    }
    
    private func runError(type: String, info: String) {
        /**do nothing*/
    }
    
    @IBAction func addClickEvent(_ sender: Any) {
        if (nil == shellInfo) {
            shellInfo = [Dictionary<String, String>]()
        }
        
        shellInfo?.append(["title": "KickShell", "path":"~", "command":"ll", "terminal":"iterm2"])
        
        tableView.reloadData()
        dumpToFile(shellInfos: shellInfo)
        updateStatusMenu()
        
        tableView.selectRowIndexes(IndexSet.init(integer: shellInfo!.count - 1), byExtendingSelection: false)
        showShellInfo(row: shellInfo!.count - 1)
        
        ifShowEditPanel()
    }
    
    @IBAction func deleteClickEvent(_ sender: NSButton) {
        let row = tableView.selectedRow
        
        if (nil != shellInfo && 0 <= row && row < shellInfo!.count) {
            shellInfo?.remove(at: row)
            
            tableView.reloadData()
            dumpToFile(shellInfos: shellInfo)
            updateStatusMenu()
        }
        
        if (nil != shellInfo && shellInfo!.count > 0) {
            tableView.selectRowIndexes(IndexSet.init(integer: 0), byExtendingSelection: false)
            showShellInfo(row: 0)
        }
        
        ifShowEditPanel()
    }
    
    /**edit event*/
    @IBAction func finishClickEvent(_ sender: NSButton) {
        if (titleFeild.stringValue.isEmpty || pathFeild.stringValue.isEmpty || commandFeild.stringValue.isEmpty) {
            let alert = NSAlert.init()
            alert.messageText = "The Title/Path/Command can not empty"
            alert.addButton(withTitle: "Done")
            alert.alertStyle = NSAlert.Style.informational
            
            alert.beginSheetModal(for: self.view.window!) { (code: NSApplication.ModalResponse) in
            }
            
            return
        }
        
        let row = tableView.selectedRow
        
        if (nil != shellInfo && 0 <= row && row < shellInfo!.count) {
            shellInfo![row]["title"] = titleFeild.stringValue
            shellInfo![row]["path"] = pathFeild.stringValue
            shellInfo![row]["command"] = commandFeild.stringValue
            
            if (0 == terminalMenu.indexOfSelectedItem) {
                shellInfo![row]["terminal"] = "iterm2"
            } else {
                shellInfo![row]["terminal"] = "terminal"
            }
            
            tableView.reloadData()
            dumpToFile(shellInfos: shellInfo)
            updateStatusMenu()
        }
    }
}

