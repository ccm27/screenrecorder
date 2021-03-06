/*
* Copyright (c) 2018 mohelm97 (https://github.com/mohelm97/screenrecorder)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Mohammed ALMadhoun <mohelm97@gmail.com>
*/

namespace ScreenRecorder { 
    public class ScreenRecorderApp : Gtk.Application {
        public static GLib.Settings settings;
        private MainWindow window = null;

        public const string SAVE_FOLDER = _("Screen Records");

        public ScreenRecorderApp () {
            Object (
                application_id: "com.github.mohelm97.screenrecorder",
                flags: ApplicationFlags.FLAGS_NONE
            );
        }
        
        construct {
            settings = new GLib.Settings ("com.github.mohelm97.screenrecorder");
            weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
            default_theme.add_resource_path ("/com/github/mohelm97/screenrecorder");
            var quit_action = new SimpleAction ("quit", null);
            quit_action.activate.connect (() => {
                if (window != null) {
                    window.destroy ();
                }
            });

            add_action (quit_action);
            set_accels_for_action ("app.quit", {"<Control>q"});
        }

        protected override void activate () {
            if (window != null) {
                window.present ();
                return;
            }
            window = new MainWindow (this);
            //window.add_class ("rounded");
            window.show_all ();
        }

        public static int main (string[] args) {
            Gtk.init (ref args);
            Gtk.Settings.get_default().gtk_application_prefer_dark_theme = true;
            var app = new ScreenRecorderApp ();
            return app.run (args);
        }

        public static void create_dir_if_missing (string path) {
            if (!File.new_for_path (path).query_exists ()) {
                try {
                    File file = File.new_for_path (path);
                    file.make_directory ();
                } catch (Error e) {
                    debug (e.message);
                }
            }
        }
    }
}