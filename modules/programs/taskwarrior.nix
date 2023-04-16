{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      programs.taskwarrior = {
        enable = true;
        extraConfig = ''
          # Urgency settings
          urgency.user.tag.bug.coefficient=5.0
          urgency.user.tag.problem.coefficient=4.5
          urgency.user.tag.later.coefficient=-6.0
          urgency.user.tag.waiting.coefficient=-12.0
          urgency.user.tag.backlog.coefficient=-20.0

          # UDA settings for tasksh
          uda.reviewed.type=date
          uda.reviewed.label=Reviewed
          # Report settings
          report._reviewed.description=Tasksh review report. Adjust the filter to your needs.
          report._reviewed.columns=uuid
          report._reviewed.sort=reviewed+,modified+
          report._reviewed.filter=( reviewed.none: or reviewed.before:now-1week ) and ( +PENDING or +WAITING )
          taskd.certificate=/home/risson/.task/keys/public.cert
          taskd.key=/home/risson/.task/keys/private.key
          taskd.ca=/home/risson/.task/keys/ca.cert
          taskd.credentials=lama-corp/risson/031459a4-0739-4ff9-a0cd-44c20a271172
          taskd.server=kvm-1.srv.fsn.lama-corp.space:53589
        '';
      };
    })
  ];
}
