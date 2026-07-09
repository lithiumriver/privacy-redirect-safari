"use strict";

// Amazon product URLs carry a descriptive slug and tracking query params; they
// collapse to a canonical <origin>[/-/<lang>]/dp/<ASIN>. Extract the ASIN and
// rebuild the clean URL, preserving a leading language prefix (e.g. /-/en) when
// present and dropping the slug, query string, and hash.
const ASIN = /\/(?:dp|gp\/product|gp\/aw\/d|dp\/product|gp\/offer-listing)\/([A-Z0-9]{10})(?:[/?]|$)/i;
const LANG = /^(\/-\/[^/]+)/;

browser.runtime.sendMessage({ type: "redirectSettings" })
  .then((redirects) => {
    if (!redirects.amazon) return;
    const url = new URL(window.location);
    const asin = url.pathname.match(ASIN);
    if (!asin) return; // not a product page (search, cart, orders, home, ...)
    const lang = url.pathname.match(LANG);
    const prefix = lang ? lang[1] : "";
    const redirect = `${url.origin}${prefix}/dp/${asin[1]}`;
    console.info(`Reformatting ${url.href} => ${redirect}`);
    if (url.href !== redirect) {
      window.location = redirect;
    }
  });
