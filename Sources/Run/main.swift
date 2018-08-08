import App
import Foundation

let swack = try Swack(.detect())

swack.addMessageListener(for: "help") { event, swack in
    swack.reply(to: event, text: "ja")
}

swack.addSlashCommandListener(for: "/createrepo") { command, swack in
    let textElement = TextDialogElement(label: "Repository Name", name: "name")
    let option = SelectDialogElementOption(label: "Public", value: "public")
    let option2 = SelectDialogElementOption(label: "Private", value: "private")
    let selectElement = SelectDialogElement(label: "Repository type", name: "type", options: [option, option2])
    let dialog = Dialog(title: "Dialog", callbackId: "callback", elements: [textElement, selectElement], submitLabel: "Create", notifyOnCancel: false) { submission in
        swack.replyEphemeral(to: submission, text: "success")
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["ls"]
        task.launch()
        task.waitUntilExit()
        print(task.terminationStatus)
    }
    swack.replyWithDialog(to: command, dialog: dialog)
}

dispatchMain()  
