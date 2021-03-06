# @licence app begin@
# SPDX-License-Identifier: MPL-2.0
#
# \copyright Copyright (C) 2013-2014, PCA Peugeot Citroen
#
# \file genivilogreplayer.mk
#
# \brief This file is part of the Build System.
#
# \author Martin Schaller <martin.schaller@it-schaller.de>
#
# \version 1.0
#
# This Source Code Form is subject to the terms of the
# Mozilla Public License (MPL), v. 2.0.
# If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# For further information see http://www.genivi.org/.
#
# List of changes:
# 
# <date>, <name>, <description of change>
#
# @licence end@
genivilogreplayer_SRC=$(SRC_DIR)/genivilogreplayer
genivilogreplayer_BIN=$(BIN_DIR)/genivilogreplayer

ALL+=genivilogreplayer

help::
	@echo "genivilogreplayer: Build genivilogreplayer"

$(genivilogreplayer_BIN)/Makefile: $(genivilogreplayer_SRC)/CMakeLists.txt
	mkdir -p $(genivilogreplayer_BIN)
	cd $(genivilogreplayer_BIN) && cmake -Dautomotive-message-broker_SRC=$(automotive-message-broker_SRC) -Dautomotive-message-broker_BIN=$(automotive-message-broker_BIN) $(genivilogreplayer_SRC)

$(genivilogreplayer_BIN)/genivilogreplayer: $(genivilogreplayer_BIN)/Makefile
	$(MAKE) -C $(genivilogreplayer_BIN)
	
genivilogreplayer: $(genivilogreplayer_BIN)/genivilogreplayer
