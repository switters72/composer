ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.14.3
docker tag hyperledger/composer-playground:0.14.3 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ���Y �=�r�Hv��d3A�IJ��&��;ckl� 	�����*Z"%^$Y���&�$!�hR��[�����7�y�w���^ċdI�̘�A"�O�έ�U���Pp��-���0�c��~[t? ��$�?��)D$!�H��q)��R�� �"b�����X64xd���Y��=��B����m�,���,dv5Y����6�L�6�d~0`m�O�C����� SGj����1�b�lږK� x�%l	���3V���fb��{��:(T2���b6��?z ��?Q�h���N����Ȇ*�!A�����)!H���X[��A�2e����
�0��ӁU�b"�V,T�*���j�bc����n���jB�@��;���'�ٴy�Rl2i�&�k:Z<��7mM�k��,��,��:�� ���@�U]1(,�`�*^k]qb���^����CM�F>��>C��S�*jP����v�2Ga6Ud�[���gԧ�:�z��(ۡ�G9�.`��#:����/;��|�X0
�e+��p��Ej��N>M���P9\��,[�㍿i�2~1�;=~i���sF��S7G6����5�GY�Qyl�)ua�H��Ou	3ߔb�y�v
eLĶ����5����3���f��ա�{�]��4�>�%��냇�}n+�����u��>�{�ɋǣ��?
���D��IbL|��ޓ���3��Fč�=õ�A�y�6��G篿���F�pX�H9a����_	<�.TӌPZM�� �?}��S5�jL��*)Wv?T�ʩ�[����<��{���S胎!q6�|����3��>]��*�bx-������0C�;Pi�
�[ظ�6���4��O�)�������n:��uf`ȱ1^
��[:}4��2A��Y�ƀά�ـ:6�^��tܡ�b���l�qL�3���Zڴk�� Vd"�\����O���f{�� �lhɓ�S�����3Jc�
����)�c7�9}��j���5k[&R�D��wE�ȎT���������Xi)M����:���{o�;� �aEc�W~�ٷF�Ps4]@Sij]��7���ˁ���!Z@�{4Z���� ����H0�'��@�Rs�A�?�s����$���Av5�k���`��O��4{;tWp��&O'�Xi��W���P/����	m��t@C&j�."���ahFc�R���J��;�7�+�;w�>W��79��Ro�P$�w;����W��ATR��{�=J�f����}�G"���X?e����Ó�����s[/�A��I�f0� P���,f�	���ޒY Z��	�\6g��N{�?L����uX�=�K K�1�+�cc���s�����,�Nydh7y��`o�����ل�ͯ���>�9��v�>�X�:�G.Bȕ�f�h�UL>��&�(�;�Dv�CA�H�A��)M��g~<�~�v�3��6و�f��7�<m���<B}h]6��۟�����F�6����G��l2qz@�D����q�eѝ�W�+��<t��^9��©�@k����O���~(���'�k��
X��|�0C�GkyOm,�Q
ǧ�_\���\?)=:�q�3�l���OO�v��;fb�稷�3a�u�Ӥ�� �6�\:_��u�Uw��T9X����&�U��=Ϯ���=�C<�]b�r��x�Y9YΧ>gʕ�A���`�6{N��,��_'�rڴ7l��_��50Yaǋ*�n��4	E�x�t��,ݩ\�o�*����B��:��h��.F�s��R��kC���#F�1P��D;���V$޿xʢ�H�o߂�3��3xj"��=�$̹���mP$�8�Ӯ!�?~~��R ҺtN�tzB'�i%LF�o��<����i� (�$�_�����s��p'�E���������X�_6���AӾ��2���´�����
���|����贁f��utLT�.�Ў�~=˾�:w��?�/ݽ�e������}��X��l�s'.����7���_	�t�����G�G��?����J`��o��±A��ed��|	:�f���v���<����#���ba'��c"N.�vw~v���^|J��c"B��tl���Ѿ�`�'V߲Q� #�{֐�D�Y��ҿޫ��X�O��˱�gҙ!�.�����Աu$e#����<~�̿UG\!�	���ŞBݘ	�0��.R����ke�0�:x�3��{g�wJ����i0p(:�����-�M��]����4}��P�o����A�|�Zs�Z���BDl�pu)d�3�R��W��a8�=�q<����@@
Aq�o�� �{�
���[�����&�,^����]���T�M�8Y��J�����d��m�ѴA����~�Ox=4���v�n*�wy)�4�76-�R<���]	�U���?w�����B��)���l H3���瀌��e ��-�]�̣�)�
�"��V�a���� �����i}�P!����,��6z�.zqSwiƳ��LQr�^���l?�Ė�&�AxIC���):&�H�K0��gi&/�ČS��ffΘh}:YƬ��raLu*��ӫ݃Bf�0����)�r����#��s���%3��Ґ�@Z�"��H�?+�wc���1��G�������>��۟���>�_�z�GJ�UOA�bYt�������hTZ������������o��������_��0e~�	Ej�"I��V]QJ�z�.)[�D�^K��p"IDRLJ�I�R"�H���V4\ۊF7��k�/_sӄ7���N�tt��/���6�������G�>�6,lښ�����6�lT��}��&���W�|5�����Y�;k�_6����mp���H��~"8sb�ͫim�a�1A�[�`��h���W0�������w����<�[�q{���5���率�IK����K1!�����+o�5�@�n54���;�aRz��%�d��A7�O�^Om:Y�o_�֠�ly���E%k��juA�oE���V����$�p��m�PP"��@q+51aJR4N��|jW���Z�S+@������E�ʔ��l>%W3���Q��S��TJVR��Oʍ|Y.:�q�E_%s}�&��LK/�R���>�_���S.3�������Q&�,����K��l�	�j�Ul�rz�y����E�\>r�)��1y�%s���uN���ix�"W�߸���%�g���M�Y{���*��ZX��M���)T3�b�ߞ���m*�BU����B5/T��Zv�ʄa�;��<Y+��^�t�>.�r�����L�@&��.�,��Y��u�v�sZ͜�%w���;�(�u���I��)��.3�BR`r�wR:)��$*��0
���rY[�]���b�VM���Lr���\� %�F&�Jy�{�]Y��ɜ��w�,���E�Z8���x�v�wr�ci2'���䮱�:9����)ܓ��P�hZ�?��uz�b%��
�a9v&e��Fo�ZM�d��魚�e��^���n#-�\�I�����e�����|��*���|�m�A'��'�������?v�D����R�XA���.w
2�GFV0%��9J�K)��+���L�c�z��-x���$BM��E<����qr�;NtSj��oT�{1�.��8�3���
��Syg�9.�BA매D������;��|���!�`0��������׌��1��l��AtsC��� �1!��?P&`��M��Ex˞�J���]uw�����c_Ê���?2��'"��u��J`�O:,珉q {�SV��+�s��&ˋlt2'� ��J�� �{���=��Z�{̝��BE|���]���4R.�{%#�4�˕���MY��b�S8j]fa*���Xj�t����9�u�/���hVGѣ��pNk��'��N� ��P�C�#���ޭ
����&.�s��>��=��e�������*��������G���e���?W���(��O���l����z�)����咒.5����L6}��ׅ����D��с���cdϲ�V)N��s�-'����#����.m�n�aOܷ�ޅ����j����θ���瞵�|���;6��%u����J���]���J�����' �;}��E�������L�,PF�/� ��FY���ݴ��,��!s���<��? ��7��lX<�4�k��"�p�FuAC�d�hC6h�/j	Xe^�Kc��?-s��)=��� E�#8� H�6Ԍm0_���mJ��t��V�����,��q�� QU�#����֕я��b�v!���g��xo��4��AXxؓ��߆����ȏ8w:<�����4Ȗ���M����$�X�ݫ���;h6���1���4���cz�\C혌�� �?^h���؃˥D�@��6z�J�K��ÆM/ B@ӄ}� -$��MY�v�؀QY��mi�K��a@L��z��dJ� x^F�l/6A�ɤ�~a��(/����J=8F'E�.o<?`*ꛬ/�@��lox4��?���<��"�z|��@릊d|�����^���Mޞ����_]�����Ƀ������F�5����v���M�f��c�I�KRs(��|	Ldu(�u��>k�i��կcLʴ��(z�dN̯;��'��8Ŏ�c���Z~SzL�R�Ȳ����٥4�_>�rJ��������^���h���<U�.�@�u"l�0j���=���/��R�c�"�r��M��ZU<)�v@��)v�������G{�,!x�*m�t�v�|E,󵡢�B�oz�a�����'�R�d��b����<��fpB��H��ٵCW҉�I�ێ��	!JE��H��q�	F����G�S�n&k�:l4LԠ���1�\Cq�D��UH�P���4�뼂u]�?�a=�T'tp�m����J7��m�F"C��!K�3��y�L����⃉ӑ�r�?}o�Jm+��B�Y���PU��}���bl�Gl�S�d���dmُ�,lc��_����k�uK��=Msq7=Ej�A����F}��#��\���c'qn���dq��N��y�؉�,P�@H3�H�b7#�!1�0,����b�!v�|�q�]�[�sZ}�^����:�����������KB?
��_R?�����?���ۓ����ݟ+�������ⷿ��_��#����pd�����^��я!V�mp���P�O?S�hHV$L
��Q���#M9�����&���V� 2*�A��h��C�/$�<
|�k���_�y�S?�~�+?��O�f��G��g�=�.�,���#o�P�z��|��] �����{�w�{����	�|���|����O;���߽yh7\h�@�)-V`��\7-Z:�RH�W6�>e:��n���
,�c� ]��^傫��!0-�pW(�FUq-���� �	n���H+	�g�4!��s�W �^C��-�g�"��y|I�mZ]���(����s昭W��� �h��P��	�Kq&.ZCw��t�9Ȏ[Dv&�fN�9c��5�*�z7���N��h����"�<۫����qP��N�6������4�`r漋fP�k��)����)�4�]�̎5]S:�K���q��t��DvV��͙�,�)+#ٕ�m!��,�f�Ӆ����w���B�Xښ��'&��Mք�E;s٤�lI�!���N����<�s�apS�>��H#M��Q����h������<��Qd�V�E������{S���` �XT#��j�LM�;�p\�[l}y��v�|����$%ͪ��Q���(=7)177��S~��Rhъ^BWg�[����䦻`/��B/��"/��/���.���.���.���.��b.��B.��".�]��K�yy�����[�'I���JF)�@�{j���D�czK��f�V��j�������P���%t�]T
���Ut��TO�LY @�p��L�N� ���u��<5b�d$=�"s���!C�4�b��[h�?�USD_nʄN�4��#�Z�p�,�ES�c��'Fcs$��u��A\�s�i���q���1	����lY��N�$��4�VD�)3�-�������c9�r����0�!͜ΔY31�W;1uA��t'�q��e"�ղ�>�p��iE�ʍrn��#2�f�v�ݎfQj�]�eޅ-Ի����/�� px�������no9֟W [��~	����Jx7�>Cދ۷��`�om�#Mm-��9�Z�����P'�|�A��.z���qGV_��x���E���-|���������7��1���a����{����,��D�,�t>oDg9QW�<S]d�H�F��֖Η���,]ru~�������˙$`y(���X͂�<]Ʌ��j�K.�]��8��46%pM`ʮ���P`�TEZd:-GY��Jqc<f!��T�Y�TdJũ�1;�+�^�Q�puv*�x67��f=u��|C=��(:>h*-}�4�y#L��vuY$���+#<j"5���R&
u<T�RݕH���&өs�w���~{�i LS��� �������-*C��.�����q$bH�ѹ%����(��U�����)��(;��2��jMY��d�����c�R�����eAt0���A�l���͜6�����.3T�aM9n̆�*�K��/h%t��#��e���ߺ�i��Pnz�r��Fy�<(�L��frzg�-.������������lȉ%]qdv�����	�X�	l}��q�,�_d��������3���2.�#��w��h����=��K��UmZH^O�#�-�2Z�dCW���1�HZ>�'�I]�f+�0��l=�W�By�T��>F�bF1fqЈ�������aT���h#KS��y6+p���mچ2g�q���S�YzL�`�#�S�r�)��|'���:Z{z�v�O�=��� S>�+�x2-l��Ua��wiA���jѼ�lT�t����K�"�4ڼ9�������0VG��d�O�<�ۭ��4�R�����b�@���e�ٍl⿼�'�"P$��"��Aa<�����ǘ�ܕBUb6��*����E2O������FH�P� �=�q�	���/U&��s�I��BA�{ޫJ)=ʕ�i||�SZ)�!y�T��؄Kb�1��v�����!��8�%����Y�d����ryT�&C�2:��Htٝ �r[���e�B��3u�<t�·KSR�>4��M��B�[��Ka!%nH^O�0D7����	��Bs>�I�R�"]���yz6@�A*��tl�0��J�Y�ױ�4h�C͍�kp(�b�Ѫ�J9V�q�1�g��Vv��eـ�|v黁w���W�����	�L�k�l�_B:�hQэ�j��2��4W�S]\�����[ț�HyY#?�HF�[R�J���Gȃ�ϟ�>��|y�mGI�wo"o+��"_g�7������C�.^ ��M�J��<}�<HI:YKk��UQw L{���8� ?��J��(�O��	������׽�<��YZ�'��+z�<B>t�O�O�Уׅ{�{��#�5��C�K���?�'2�׃��t��?�
m������}�������`����z���I�U�m��\C��^�t�h*Az���]+3�o=�t�����X�Hŀ�bGn�qH�@�Fh�E���~�/z~���?��_��.nw� ��|�$���Q�Z��]�^6����i�����u������*�h�k�rzU�*�dG'Nv��e��15������/��K6$�d���~$�(r�����Òt� 䣍�"X�E�jY� =�]�}��1�..��;ol�0hY���`]��8�N�A����T��C��Y`P ��ԧB�|5��+ ����Zb�FV�&�'��w��GA�~��=�/�3� "+hљ^�|�l���ֺO;Ի�ƫg�d4�{e����s��x�.��
f��VTϳ^V&֟�:q��P4��?ƒ�u��8�ֽF�hǫ̮�$�viy=_�6с>�w�2`:�X`j����x�[	`�'갥�%�$XY5
��pEd����\N _n���3r�ď��Y�D�^�A]ןw�i��&��������jm��]�
]���g	?ϯj�H&#]���;�/�����o���t��=���ި�5�w oAxs��'�s(sc�6A|G�m�7N~���'���8\\�s��5�+u��3�`@!�6[r8?h��C]���&���	��ֹ�5Q4�l]\/G�ؖ�'�=��(
�q.�0N�� �� .���e�b�g��ٗ1��6�18�x1���R�/ٰS�	���n��r�8�I𢍷�]x�t�1��J��B�z�iJ*�p���m�B�`�����BN���^;8Hv��o��V�a�(X�Hp�W��:�4�4
vY?fv ���t���ڱ2XC�Y_�p��Nm.�F7�y�Z�4�,k���r�o�������i��"�ze�J�5,y��UǞ�D�ӄղ�p,����[6�7�^���i��e�M�[o�R��w[��h�����ZL�o���n��V��v5!$NO�9|r�k����@=X�T�5�l�/ �C`���qe��*��D�ࡃ|�F���u��mkCL�D�)�İ����y�i�vq�/��������4T�ܻ����886�P1�Ѥ�ȍuK���5��c�Q�Oq�G�w���w�_�b��z����ύ���C�\��������E����>Xq���  �e[%;bnزS;�F@4�ٷ�YݳN�L�����3��-tguM�(X��~��V;:�|tY)��,�g���j׺^��p��X���S�~�v$���v����$5�H�P$2���6E�[-��ˑ6.ID3d�#�f�َQR8U$�����-Ȁ��]n"��aV�3'��e�v�OZ�O6�c[��'֓�`�0fȵG�cA�	���+��U�Ǥ&EJ�fG��,�8��[��$���1%�E����2!!����ƔpD�%JR��	>i��N�ϱ|"gcf�m�7]O��[zr��8K��';�����b+�}���;2^���b^ȶ�"�-�NrY�Hg�2�d��p�g�Ҝv.�ƗD.K�l�+��aк�.��-�%�S9�<�"�n�rO�/��vɠ�tF(�y���x�� ��V��=��*�
��ٙNg���@;#p����Q��	ii{�֙�uP�������7� l����ԝ��l7<�s�D�;�L�v��3d����d7�_r�r1�oE�����"�<�g�gy�+n:|O�|6�cW9m�`9��\�Zθ,���Y��t��OP��љ4A'ӡc[=���	K���,����ȟ��f-m����O���\I��	>y���j�x*X�{�љ���z�k�cHng��ڵ�i1��3�����c�VْH�����E��Kܳ8y�2������8cr�r'ȍ�JƢ�ʠ��O��'O�كw&��%MW.`a|}�@�1t�"����d�������|�l�Ml�9c�o�.�c�[��W�vY+CY?[}�y��sH#�:vkk'���fWH�+�oE�;�˜������y�:P�Q���Ͷ�w��v�80`�w��/a���#�q��ytG7^��e����Gz��%�o��!"�����M��������}��������ۄ=�=�}��-�?:����WA�8�)��H� ����%��ϋ?	��4|eӾ��%�qr��/����{I444/��}���+a��;�쿽�}����]`[��X;�qKv�qLn�CdK��V,�[
Ţ�P+DFB�H8�41Y�Ä�:�_u~�ӫ��Q���w������6�d�8���>��CC��2:M�#��}������t��뺒�Wf��F�T���S�"���6����a9�Ck ��"Z���^oKE�I���Տ�NJ�zoҩ']-����2�I�0��{q���_���WA����/�|�ocC�{���;�c�os��S���}�WA�؎���A��#�K�_������A��������?29��}�{�� �}�S�N����.���������Kz�?���@�S�����?��{��$�-�����Gz��?�#��%���/��3LP[����{�֥&�u����1Z3��MEE�/g "���Z��hw%��N�|��JU��5�ZsW8��ꄣ:��#�?$��d��?*�/����P����	�g�?��+B���5 ���!�?I���o��֭��6��?�n�_��8��B'b�[H���e-���!���O��������1�������~b���,���ɬ
��߷�y_��VI�SI�W����z�"mf�ݢ�k��
g7�r�(�Bs�l������w���Xآl�̓M�S����������}����϶X�\�;�A=:���m0����fO�6I/��v5_d;�o�>��~�\�˃4���8`g�_3e#��g���BeZ�c,k��:t�?�m�0�[^<e��χ�^ײ�Q1kn��n�j�������� 
@=�����H�?��kZ�)QU���I�	�W���'����z��'���W�y��]�����H���{��� �W����7A���@����������s���/��s&�S1=�s��uk�X7u~��+����׺�SY_x��Ő�������7��4 �Z����6�]p�vÍfc�ϴx�Q]V�2��pz��{���!���ow�1;��Sidxh��C�45)뱿���h��K]���Ȇ(�kI��d��R�/m|�����6�}��CK[�:�����tJ��Ӳ�b�m���v�XSn/��d6���m1�Ιb��EhҒ4�WL��QC+�M>���1B:2Fsj���o@B�O���
 ��V�%?���� ����P����K���+J�?��b�,1cx&�yg!�����C>)��Y.$� ĩ�J�<�ጀ�
��,���j�3������s"��f�i�X���i_
�l#
�Tt�-c�����)������=���)P��	��^��H�Y�.z�~59�S�M�-%��S�<VEq{|p��Y�5c&n���Y�g���V�p�����P������o�@���_}@��a��6 ������kX�������>����hZ�s���i;���Ǝ�pΊ�����^�K�[�����^��=���#94�7/9�2�������慝��|�h|��8��S��#�qYRg~l8�xS�EƖ*�:�t����[������& p��?���������������/����/�@������H�?�{�	��
������b�K�� �mY���f���
�&�y���?[֒�_��{�k;̱��Z�� �˃?p �g=����Tۣu��*U�v��g ��i��CW���!��2ݒ+|���ؠ�jJz��z��Ҷ�a[.C���Q��'�:kp���e/����7k���v�����b�z����p��{y��� �mI�!]끽�-�*>1q��I_�4�x���HR�(�n$�,�xޜ�)�������n X�rk+���V<�Ԥ�I��ox<i Ւ5u����������-C�1��)I�sE�m����v#:˗���H�HhFv�w.2Ŋ��&5:���3�|�%�h�/+����"ڋ(�?�~��h�U�����袊��V���`8�?� 
�O�O�?��_	*���CU��w�����B�����������7������P��#?`?��qn��2�C�|�gYZ�8�g�����4�"�/D4>�G���a@��6��C�����_�W����t��c���D����0w#�dM�N-&�4�k�`����b�%�4ҭ����ß��n(��%�b?�㤺����e��K�%O���c�p]R���@{-g�ǩM��(��	���?��T����[�C���w������g)��*����?��U�j�ߟm�xG����u������_M����ۗ��`DP�o�;ł�W����C����y�oGf�2kJ�K:�T]����ﰬe�[����J��Gf�o�a?2�}kec�8�]ck<<�cF|ީ�<�������ϒE�Wg�1Fi�ę�d���́U�x�t�ζ����НO}]�[��N��<��
�7mNˍ�`�z�ziǅ�t�g�t��r�׬�۵���7�sK���9I�l?�
}��6vj~����k$d��о|�ʎECue͒�\�XLV�]�L#��K����kp��D�v�#�$Ϛ�یΦ�{���T�|U+�;��ddt>�\dZ�N3��H�eW��U����5��绣
��o������5�Z��ApԀB��d��� ����7���7�C������: I@��{�?�����r��\ T�D��$�������������������������������<�Q��O�OC�_	P���
��
T������P7������8��.���Q3����k������J� �C8D� ������'���G%@��!�jT��ߛ�@C�C%��������	�G<��0�Q��R#�������<� �W���Bj 
�����*�?@��?@���A�դ� �F@��{�?$����-��p���D��$�����J ��� ���Po��D�A�c%@@��I��u���[�!����?��^	����(��0�_`���a��_]������G����Ut��>��@��{�?���� �?T��� �b0�#��x����y!��t��MRѕ$X~��!E�O�/���O��������.P��%���	��Cmt������{���\+N�*P������ǵ�ד�4i
�*`1�/�p��Df{�^��-%
ˡnm��b(��(�'9�\s��l�2�(G�F^�� �1z�r/֐�0�uĸ��Nby1޺izt�dD���T�㥧t<�D��H�Ki���~�
����5��k���
��P��$��j���{����u��!P�����Ϭ�!e0�ơ���VϰC�7���r0+���l���"f���T�9��`��Y6�~�!���6K�GŚO8f3_��3qni��;=J�~�.���w�����5��t�����BeL���h�����" p��?���������������/����/�@������H��������������?�?���(y,�٭=��剗b����_+����U�ݤ�"y��&�`�\bߒ�Ge=w�ʜ��PN+a��vg�1�!hl��q�u�Y8�����c��X���d�bY�ݜ�M��b6�Kz�w|37�i�=j�q�镾e��\:�6�o�-�0��{a/�jK���ĥh`o.�I_�4�x���HR�(�n$��X�y̜�)��������h���u�s���X\H"�L*�g��o�F���;{s�x�����D҆�El���j�,^��� �i�u&L#:�Us��ng�����A�O��h��-������_�#��[	>��}���_��G��U ��������w%����K��x!�*����?��@��I�x�����U�����L�P��c����G�$�_x��3Yg�/��y�X�v�pG���l�S�C������RD���!�_7KӢ��)�u����a���{�w����Y������Kߐ�u9�Y�7��Z��9�d숎���VM���T����Q��Y#g��@���oTa���U�ʹ8��ɳl-&ղ�d��{j6��#Lv���hѦ�%<%_.�)�G쿶h�+��}��v��zY)����EE�m?�囝�CV�i�/[�$K�ۛ:;�!Y�mY�1̷�wO͎�4�y�=��i��|�2�fGT$UL$r�Kl^"b��X��H0��X�q2����5�DDj7b-���K�}��G�ĞV�{jS����±`��u_�u}�;������+B5��<`	��9OФ/̩���l(�q��Iv>9��>�lȄx��!1���
�����U���_%����
�Ŏw8j�$X8�z��tv��u�;`���\xR�i��Q��Y�`�+7���ߊ������w����
����z���U�
>���!�*�����8�ǂ��o������_�?����N�Hi|1Un8ag�����j���h}�S����l������q?�G�����}��71$��������þ�����`w,�$Z���l��d����0���>6����Z0�4�>�}���	�0������b����d��Ɖ�uG7�{��w���'����&��f���ݐG�;��t'j���L[v���tU�:����ItY&�p�f3"p'�p�jҿ�(1�M+߬�"���O5��:�sK�ͅ���:jx�mo�-�t3Ԍ���_4n���}�;P����������0by���9O���_�^�b�(��>����o«.��C�$�\!x���Q���~��z�����x�L���a7Y����w�;�4Z�3=���R�CU�άv�O���˖�j��+[���V|��������p��� 
������
T���o��p�#� �����!��>T���1�BU��?�����#���o��[�C���Gk�mj����c���~������?�����z_���*����Gec.�!
���DOG�ez1���TVs�^�^S>?V��j�޹��ۺ�w����+�����;�'5�m���_��I�:�<�<䡧Nn�"ؾ�޺��@@Q����v'��L:3i6ק*i�A�-|�Z{�����5���J�w]�u%���uNj�G�3�u����;z*��]k4�t]�o���j�t��9>�V{f4�{�Y�b9m�U:�[r�劘��?ݶZ�jx���)4����c�������q��Y�R7V<�oMֳ�F�k���^[�?^l��4���Vْ�6/Ju�����Bhj��1)uLy62��x5������*&-%�h�Y�Z?�z��ʀ)�u�ZIuG��e��8���j��I�.����\��O������7��dB�����W���m�/��?�#K��@�����2��/B�w&@�'�B�'���?�o��?��@.�����<�?���#c��Bp9#��E��D�a�?�����oP�꿃����y�/�W	�Y|����3$��ِ��/�C�ό�F�/���G�	�������J�/��f*�O�Q_; ���^�i�"�����u!����\��+�P��Y������J����CB��l��P��?�.����+㿐��	(�?H
A���m��B��� �##�����\������� ������0��_��ԅ@���m��B�a�9����\�������L��P��?@����W�?��O&���Bǆ�Ā���_.���R��2!����ȅ���Ȁ�������%����"P�+�F^`�����o��˃����Ȉ\���e�z����Qfh���V�6���V�Ě&_2)�����Z��eL�L�E��؏�[ݺ?=y��"w��C�6���;=e��Ex�:}���`W��ؔ��V�7�r�,IO��j]��XK��]��N�;u�dE?�)�Z�ƶ�͗�
�dG{�ݔ=!��4]�ݢ�:肸�Bbfk�6C�VXK2�*C�	���b���q�cתG��<s�����]����h�+���g��P7x��C��?с����0��������<�?������?�>qQ�����?��5�I˻Z�C���Hb1�(�e��q˶�Ӷ���rgO���_�:Z���`�э����fCM�"vX"�h�.�j��oՋ�mXù��5vy���|�TǮ6�Wr`R��
=	��ג���㿈@��ڽ����"�_�������/����/����؀Ʌ��r�_���f��G�����k��(����i=�0r�������M����+bM�ɔ��į�@q��`�r�M Alz�q�%I�ݟE�ݢ��ƚ>��uwR�K"}&V<.l����ة����$�M�Aj=z�\ks��u�]�6A��6�zE�6�l����ӯ��ya�h������d�]��]��OE�;���{Ex��$%N�� ;��YU+�c���{i�a/l>%��j�S(�tj9�����lԚ{�Lkl�,��fS�
��A����*aJ�t,�a�u�]��,�=btywุmȤ֮4����m������X��������v�`��������?�J�Y���,ȅ��W�x��,�L��^���}z@�A�Q�?M^��,ς�gR�O��P7�����\��+�?0��	����"�����G��̕���̈́<�?T�̞���{�?����=P��?B���%�ue��L@n��
�H�����\�?������?,���\���e�/������S���}��P�Ҿ=�#���*ߛps˸�����q�������ib��rW���a&�#M��^��;i������s��������nщ���x�ju~�I�Z�����be�Ì��yyC��Rѧ���!;3��08A���rf����i�������(M���h��s�/v%�Wӫ��#
��CK.H��G��m�>+�Z�[�e�:	�zޯ�L��3�uj�n6#���YMڒ��IV'��f5�������>v+E,D�\0k�0ۻce�2��4�}"8*�bu;���`�������n�[��۶�r��0���<���KȔ\��W�Q0��	P��A�/�����g`����ϋ��n����۶�r��,	������=` �Ʌ�������_����/�?�۱ר/"a�ri���As2����k����c�~�h�MomlF��4�����~��Pڇ�Zy�����E��T4��xOUg=��o*ڴEo�:_�!�)��+Q��>{�fq� h�v������Ʋ��#�s �4	��� `i��� �b!�	�=n��r���"�+�r�0e�U����taQ�{��'�zWRD6,oZr��#�rXa�)��A,�6u�+�ք�b}���n�&�ue����	���O���n����۶���E�J��"��G��2�Z��,N3�rI3�ER�-��9F�Xڢi�T6YʰH�'-�5L���r����1|���g&�m�O��φ��瀟�}�qK��t��'l$���Ҩ��'�^[�V5s���GoB��]0�@����OD��W�5&�X%^�vQ�Z��\�N%�.,OÎ9�z����,�T-+��>v�e7�����%�?��D��?]
u�8y����CG.����\��L�@�Mq��A���CǏ����n=^,kzGVEbNbb�h��r����֢�S�c'�n��?�/��p��}߯0���ˬ	)�c�c�:b'dq��uz@̏-��+>�jFmY7��zDg��q�Ckrp��ג���"������ y�oh� 0Br��_Ȁ�/����/������P�����<�,[�߲�Ʃ�gK������scw߱�@.��pK�!�y��)�G�, {^�e@ae�;m]墭�u���Պ�V���i��Z��Q�E%�S[Ec9+�ё���`���j�<�N���0�P��TiVhm��z)��ӗf��y�&��'>^�҈���օ8e�;��qS�:_ ��0`R��?a~�$��PWKUE҉ٶ�bN��w��1���(%g�)��Y�&��p�/�R��m��^ľ*(�T$�Օ��Ժ��eC�G��]�KN���qmώ-k`y�b��#��`��a�������Bo�gvw>�2=�8-�9����ő����>:�������Lb�}��4�������6]<�gZd�wO����/;����I��{A����H����#��w��_tHw���M\z�s�gSAN>&tB���E�.מ���?�_w�y���n��#J�u����LN�鏃�˃�?&w,��Z��ϛ�����y��>%Q�q�}��������q_��4����������q	]�7�zp"�sq�	�7�������F��^�O�Fs��=�~g��T��4���c䤯v��	=���?;W�$r��Ozd9�t<Z���39��	�����U�އw���s<��lx|����B������������;�����;����UrT��-�$��ݧ�;���|��H* �m��u�?��>���:y[�����|�n�^}�%�jy^?�f�6����	�<���Jvs\CK�Y��x�_�s]ǵ�u"o�������;�R���7�8P���p���k-H?��mt3��4���k����k��skrvg�=�O�y���L�M3 ���^:��~�7·���+���I�L�kaN��0#�X|n<�g�&��ɪ����)%-��"���Ɠڽ��N�����w�v��ȏ���I�	�0��څ_R�ûW5�2=�;��K����������>
                           ���L{�� � 