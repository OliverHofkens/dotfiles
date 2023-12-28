use std::env;
use std::ffi::OsStr;
use std::fs;
use std::io::BufReader;

use chrono::{DateTime, Duration, Utc};
use serde_json::{json, Value};

const SSO_URL: &str = "https://gorillini.awsapps.com/start";
const SSO_CACHE: &str = "/.aws/sso/cache/";
const EXPIRED_MSG: &str = "Expired";

fn main() {
    let cache_dir = {
        let mut home = env::var("HOME").unwrap();
        home.push_str(SSO_CACHE);
        home
    };

    for item in fs::read_dir(cache_dir).unwrap() {
        let path = item.unwrap().path();
        if path.is_dir() || path.extension() != Some(OsStr::new("json")) {
            continue;
        }

        let file = fs::File::open(path).unwrap();
        let reader = BufReader::new(file);
        let content: Value = serde_json::from_reader(reader).unwrap();

        if content.get("startUrl") != Some(&json!(SSO_URL)) {
            continue;
        }

        if let Some(expiry) = content.get("expiresAt") {
            let exp_date = DateTime::parse_from_str(expiry.as_str().unwrap(), "%+").unwrap();
            let remaining = exp_date.signed_duration_since(Utc::now());

            if remaining > Duration::zero() {
                println!("{}", display_duration(remaining));
            } else {
                println!("{EXPIRED_MSG}");
            }
            return;
        }
    }
    println!("{EXPIRED_MSG}")
}

fn display_duration(mut dur: Duration) -> String {
    let mut buf = String::with_capacity(8);

    let hours = dur.num_hours();
    if hours > 0 {
        buf.push_str(&format!("{hours}h"));
        dur = dur - Duration::hours(hours);
    }

    let mins = dur.num_minutes();
    if mins > 0 {
        buf.push_str(&format!("{mins}m"));
    }

    buf
}
