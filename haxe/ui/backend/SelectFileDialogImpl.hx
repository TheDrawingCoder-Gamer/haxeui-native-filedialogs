package haxe.ui.backend;

#if (hl || cpp || neko)
import haxe.io.Path;
import haxe.ui.backend.SelectFileDialogBase;
import sys.io.File;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
class SelectFileDialogImpl extends SelectFileDialogBase {
    public override function show() {
        validateOptions();
        var files = systools.Dialogs.openFile("Select a file", "", null, options.multiple);
        if (files != null) {
            var infos:Array<SelectedFileInfo> = [];
            for (file in files) {
                infos.push({
                    name: Path.withoutDirectory(file),
                    fullPath: file,
                    isBinary: false
                });
            }
            
            if (options.readContents == true) {
                for (info in infos) {
                    if (options.readAsBinary) {
                        info.isBinary = true;
                        info.bytes = File.getBytes(info.fullPath);
                    } else {
                        info.isBinary = false;
                        info.text = File.getContent(info.fullPath);
                    }
                }
            }
            
            if (callback != null) {
                callback(DialogButton.OK, infos);
            }
        } else {
            if (callback != null) {
                callback(DialogButton.CANCEL, null);
            }
        }
    }
}
#end