"use strict";

const bypassPaths = /\/(gallery|poll|rpan|settings|topics|media)/;

function redirectReddit(instance, url) {
  if (url.host === "i.redd.it") {
    return `${instance}/img${url.pathname}${url.search}`;
  }
  return `${instance}${url.pathname}${url.search}`;
}

browser.runtime.sendMessage({ type: "redirectSettings" })
  .then((redirects) => {
    if (redirects.reddit) {
      return browser.runtime.sendMessage({ type: "instanceSettings" });
    } else {
      return null;
    }
  })
  .then((instances) => {
    if (instances) {
      const url = new URL(window.location);
      if (!url.pathname.match(bypassPaths)) {
        let instance = instances.reddit;
        if (
          !instance.startsWith("http://") &&
          !instance.startsWith("https://")
        ) {
          instance = "https://" + instance;
        }

        const redirect = redirectReddit(instance, url);
        console.info(`Redirecting ${url.href} => ${redirect}`);
        if (url.href !== redirect) {
          window.location = redirect;
        }
      }
    }
  });
