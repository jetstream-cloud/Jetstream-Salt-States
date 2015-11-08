#! /bin/bash
# sequence of ceph-deploy prepare commands to initialize osd's disks and journal partitions

ceph-deploy osd prepare --fs-type xfs --zap-disk r04s01:/dev/sdb:/dev/sda5 r04s01:/dev/sdc:/dev/sda6 r04s01:/dev/sdd:/dev/sda7 r04s01:/dev/sde:/dev/sda8 r04s01:/dev/sdf:/dev/sda9 r04s01:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r04s02:/dev/sdb:/dev/sda5 r04s02:/dev/sdc:/dev/sda6 r04s02:/dev/sdd:/dev/sda7 r04s02:/dev/sde:/dev/sda8 r04s02:/dev/sdf:/dev/sda9 r04s02:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r04s03:/dev/sdb:/dev/sda5 r04s03:/dev/sdc:/dev/sda6 r04s03:/dev/sdd:/dev/sda7 r04s03:/dev/sde:/dev/sda8 r04s03:/dev/sdf:/dev/sda9 r04s03:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r04s04:/dev/sdb:/dev/sda5 r04s04:/dev/sdc:/dev/sda6 r04s04:/dev/sdd:/dev/sda7 r04s04:/dev/sde:/dev/sda8 r04s04:/dev/sdf:/dev/sda9 r04s04:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r04s05:/dev/sdb:/dev/sda5 r04s05:/dev/sdc:/dev/sda6 r04s05:/dev/sdd:/dev/sda7 r04s05:/dev/sde:/dev/sda8 r04s05:/dev/sdf:/dev/sda9 r04s05:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r04s06:/dev/sdb:/dev/sda5 r04s06:/dev/sdc:/dev/sda6 r04s06:/dev/sdd:/dev/sda7 r04s06:/dev/sde:/dev/sda8 r04s06:/dev/sdf:/dev/sda9 r04s06:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r04s07:/dev/sdb:/dev/sda5 r04s07:/dev/sdc:/dev/sda6 r04s07:/dev/sdd:/dev/sda7 r04s07:/dev/sde:/dev/sda8 r04s07:/dev/sdf:/dev/sda9 r04s07:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r04s08:/dev/sdb:/dev/sda5 r04s08:/dev/sdc:/dev/sda6 r04s08:/dev/sdd:/dev/sda7 r04s08:/dev/sde:/dev/sda8 r04s08:/dev/sdf:/dev/sda9 r04s08:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r04s09:/dev/sdb:/dev/sda5 r04s09:/dev/sdc:/dev/sda6 r04s09:/dev/sdd:/dev/sda7 r04s09:/dev/sde:/dev/sda8 r04s09:/dev/sdf:/dev/sda9 r04s09:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r04s10:/dev/sdb:/dev/sda5 r04s10:/dev/sdc:/dev/sda6 r04s10:/dev/sdd:/dev/sda7 r04s10:/dev/sde:/dev/sda8 r04s10:/dev/sdf:/dev/sda9 r04s10:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r05s01:/dev/sdb:/dev/sda5 r05s01:/dev/sdc:/dev/sda6 r05s01:/dev/sdd:/dev/sda7 r05s01:/dev/sde:/dev/sda8 r05s01:/dev/sdf:/dev/sda9 r05s01:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r05s02:/dev/sdb:/dev/sda5 r05s02:/dev/sdc:/dev/sda6 r05s02:/dev/sdd:/dev/sda7 r05s02:/dev/sde:/dev/sda8 r05s02:/dev/sdf:/dev/sda9 r05s02:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r05s03:/dev/sdb:/dev/sda5 r05s03:/dev/sdc:/dev/sda6 r05s03:/dev/sdd:/dev/sda7 r05s03:/dev/sde:/dev/sda8 r05s03:/dev/sdf:/dev/sda9 r05s03:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r05s04:/dev/sdb:/dev/sda5 r05s04:/dev/sdc:/dev/sda6 r05s04:/dev/sdd:/dev/sda7 r05s04:/dev/sde:/dev/sda8 r05s04:/dev/sdf:/dev/sda9 r05s04:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r05s05:/dev/sdb:/dev/sda5 r05s05:/dev/sdc:/dev/sda6 r05s05:/dev/sdd:/dev/sda7 r05s05:/dev/sde:/dev/sda8 r05s05:/dev/sdf:/dev/sda9 r05s05:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r05s06:/dev/sdb:/dev/sda5 r05s06:/dev/sdc:/dev/sda6 r05s06:/dev/sdd:/dev/sda7 r05s06:/dev/sde:/dev/sda8 r05s06:/dev/sdf:/dev/sda9 r05s06:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r05s07:/dev/sdb:/dev/sda5 r05s07:/dev/sdc:/dev/sda6 r05s07:/dev/sdd:/dev/sda7 r05s07:/dev/sde:/dev/sda8 r05s07:/dev/sdf:/dev/sda9 r05s07:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r05s08:/dev/sdb:/dev/sda5 r05s08:/dev/sdc:/dev/sda6 r05s08:/dev/sdd:/dev/sda7 r05s08:/dev/sde:/dev/sda8 r05s08:/dev/sdf:/dev/sda9 r05s08:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r05s09:/dev/sdb:/dev/sda5 r05s09:/dev/sdc:/dev/sda6 r05s09:/dev/sdd:/dev/sda7 r05s09:/dev/sde:/dev/sda8 r05s09:/dev/sdf:/dev/sda9 r05s09:/dev/sdg:/dev/sda10
ceph-deploy osd prepare --fs-type xfs --zap-disk r05s10:/dev/sdb:/dev/sda5 r05s10:/dev/sdc:/dev/sda6 r05s10:/dev/sdd:/dev/sda7 r05s10:/dev/sde:/dev/sda8 r05s10:/dev/sdf:/dev/sda9 r05s10:/dev/sdg:/dev/sda10

