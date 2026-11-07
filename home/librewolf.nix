{pkgs, ...}: {
programs.librewolf = {
  enable = true;
  
  policies.ExtensionSettings = {
    "{3c078156-979c-498b-8990-85f7987dd929}" = {
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
    };
  };
  
    profiles.default = {
    isDefault = true;
    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
  

    userChrome = ''
      #TabsToolbar { visibility: collapse !important; }
      #sidebar-header { display: none !important; }
    '';
    # Sidebery needs NUR (rycee's firefox-addons) or a policy install
    };
};

}
