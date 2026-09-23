#!/usr/bin/env nu

def open_file_manager [target: string] {
    dolphin --select $target
}

def notify_and_handle [target: string, kind: string] {
    let meta = match $kind {
        "screenshot" => {
            app: "Snipping Tool"
            icon: $target
            title: "Screenshot copied"
            actions: [-A "default=Open" -A "folder=Show in folder" -A "edit=Annotate"]
        }
        "record" => {
            app: "Screen Recorder"
            icon: "video-x-generic"
            title: "Recording saved & copied"
            actions: [-A "default=Open" -A "folder=Show in folder"]
        }
    }

    let result = (notify-send
        -t 5000
        -a $meta.app
        -i $meta.icon
        ...$meta.actions
        $meta.title
        ($target | path basename)
        | complete
    )
    match ($result.stdout | str trim) {
        "default" => { xdg-open $target }
        "folder"  => { open_file_manager $target }
        "edit"    => { satty --filename $target }
        _         => {}
    }
}

def capture_screenshot [] {
    let dir = ($env.XDG_PICTURES_DIR? | default $"($env.HOME)/Pictures") | path join "Screenshots"
    mkdir $dir
    let file = ($dir | path join $"screenshot-((date now) | format date '%Y%m%d-%H%M%S').png")

    let res = (grimblast --freeze copysave area $file | complete)
    if $res.exit_code != 0 or not ($file | path exists) { return }

    notify_and_handle $file "screenshot"
}

def toggle_recording [] {
    if (pkill --signal SIGINT -x wl-screenrec | complete).exit_code == 0 { return }

    let dir = ($env.XDG_VIDEOS_DIR? | default $"($env.HOME)/Videos") | path join "Recordings"
    mkdir $dir
    let output = ($dir | path join $"recording-((date now) | format date '%Y%m%d-%H%M%S').mp4")

    let clients = (hyprctl clients -j | from json)
    let rects = ($clients | each { |c| $"($c.at.0),($c.at.1) ($c.size.0)x($c.size.1)" } | str join (char newline))

    let geom = ($rects | slurp -o | complete).stdout | str trim
    if ($geom | is-empty) { return }

    notify-send -t 2500 -a "Screen Recorder" -i media-record "Recording started" "Selected area. Press hotkey to stop."
    wl-screenrec -g $geom -f $output

    if ($output | path exists) {
        wl-copy -t text/uri-list $"file://($output)"
        notify_and_handle $output "record"
    }
}

def main [subcommand: string = "screenshot"] {
    match $subcommand {
        "screenshot" => { capture_screenshot }
        "record"     => { toggle_recording }
        "stop"       => { pkill --signal SIGINT -x wl-screenrec }
        _            => {
            print -e "Usage: snip [screenshot|record|stop]"
            exit 1
        }
    }
}
