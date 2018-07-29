/*Strike by Appiphony
Version: 0.9.0
Website: http://www.lightningstrike.io
GitHub: https://github.com/appiphony/Strike-Components
License: BSD 3-Clause License*/
({
    unrender: function(component) {
        this.superUnrender();

        window.removeEventListener('click', component.handleClick);
        window.removeEventListener('keydown', component.handleKeyDown);
    }
})