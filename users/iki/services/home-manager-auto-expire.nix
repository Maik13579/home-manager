{ ... }:
{
  enable = true;
  timestamp = "-7 days"; # Remove generations older than `TIMESTAMP` where `TIMESTAMP` is interpreted as in the -d argument of the date tool.
  frequency = "weekly"; # The interval at which the Home Manager auto expire is run.
}
